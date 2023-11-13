//
//  ChartViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/12.
//

import UIKit
import FSCalendar
import DGCharts

final class ChartViewController: BaseViewController {
    
    let mainView = ChartView()
    var pieData: PieChartData?
    var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    var data: [Mood]?
    let moodRepository = MoodRepository()
    var chartDataCount = 0
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
        mainView.chartTableView.delegate = self
        mainView.chartTableView.dataSource = self
        mainView.chartButtons.forEach { $0.addTarget(self, action: #selector(chartButtonClicked), for: .touchUpInside) }
        mainView.headerView.backTodayButton.addTarget(self, action: #selector(backTodayButtonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for button in mainView.chartButtons {
            if button.isSelected {
                chartButtonClicked(button)
            }
        }
    }
    
    @objc private func backTodayButtonClicked() {
        mainView.calendar.select(Date())
        selectedDate = Date()
        for button in mainView.chartButtons {
            if button.isSelected {
                chartButtonClicked(button)
            }
        }
    }
    
    @objc func chartButtonClicked(_ sender: UIButton) {
        
        switch DateRange(rawValue: sender.tag) {
        case .daliy:
            data = moodRepository.fetch(dateRange: .daliy, selectedDate: selectedDate, completionHandler: { startDate, endDate in
                self.mainView.dateRangeLabel.text = startDate.toString(of: .dateForChart)
            })
        case .weekly:
            data = moodRepository.fetch(dateRange: .weekly, selectedDate: selectedDate, completionHandler: { startDate, endDate in
                self.mainView.dateRangeLabel.text = "\(startDate.toString(of: .dateForChart)) ~ \(endDate.toString(of: .dateForChart))"
            })
        case .monthly:
            data = moodRepository.fetch(dateRange: .monthly, selectedDate: selectedDate, completionHandler: { startDate, endDate in
                self.mainView.dateRangeLabel.text = "\(startDate.toString(of: .dateForChart)) ~ \(endDate.toString(of: .dateForChart))"
            })
        default: print("")
        }
        
        if data == [] {
            pieData = nil
            pieData?.notifyDataChanged()
        } else {
            pieData = setChartData(data: data ?? [])
            chartDataCount = data?.count ?? 0
        }
        
        mainView.chartTableView.reloadData()
    }
    
    func setChartData(data: [Mood]) -> PieChartData {
        let moodCounts = moodRepository.countMoods(moods: data)
        
        var moodStatsResults: [String : Double] = [:]
        let allCount = data.count
        
        var moodEntries: [PieChartDataEntry] = []
        var colorSet: [UIColor] = []
        
        for (mood, count) in moodCounts {
            moodStatsResults[mood] = (Double(count) / Double(allCount)) * 100
//            let icon = NSUIImage(named: mood)?.downSample(scale: view, size: CGSize(width: 10, height: 10))
            let label = String(format: "%.1f", moodStatsResults[mood] ?? 0) + "%"
            moodEntries.append(PieChartDataEntry(value: moodStatsResults[mood] ?? 0, label: label))
//            moodEntries.append(PieChartDataEntry(value: moodStatsResults[mood] ?? 0, icon: icon))
            colorSet.append(UIColor(named: mood + "_Background") ?? .lightGray)
        }
        
        let dataSet = PieChartDataSet(entries: moodEntries)
        dataSet.colors = colorSet
//        dataSet.drawIconsEnabled = true
//        dataSet.iconsOffset = CGPoint(x: 0, y: 30)
        dataSet.valueTextColor = .darkGray
        dataSet.valueFont = Constants.Font.extraBold(size: 14)
        dataSet.drawValuesEnabled = false
        dataSet.selectionShift = 10
        
        return PieChartData(dataSet: dataSet)
    }
    
}

extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.reuseIdentifier) as? ChartTableViewCell else { return UITableViewCell() }

            cell.pieChartView.notifyDataSetChanged()
            cell.pieChartView.data = pieData
            cell.selectionStyle = .none
            
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartListTableViewCell.reuseIdentifier) as? ChartListTableViewCell else { return UITableViewCell() }
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 270
        default: return 160
        }
    }
}

extension ChartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartListCollectionViewCell.reuseIdentifier, for: indexPath) as? ChartListCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
}

extension ChartViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentDate = calendar.currentPage
        mainView.headerView.headerLabel.text = currentDate.toString(of: .yearAndMouth)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        mainView.calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        if date != Calendar.current.startOfDay(for: Date()) {
            calendar.appearance.todayColor = .clear
        }
        for button in mainView.chartButtons {
            if button.isSelected {
                chartButtonClicked(button)
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date > Date() {
            return false
        } else {
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date > Date() {
            return Constants.Color.Text.basicPlaceholder
        } else {
            return nil
        }
    }
}
