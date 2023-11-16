//
//  ChartViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/12.
//

import UIKit
import FSCalendar
import DGCharts

struct MoodData {
    var moodCount: [String: Int]
    var sortedMoodName: [String]
    var sortedPercent: [Double]
}

final class ChartViewController: BaseViewController {
    
    let mainView = ChartView()
    var pieData: PieChartData?
    var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    var data: [Mood]?
    let moodRepository = MoodRepository()
    var chartDataCount = 0
    
    var moodData = MoodData(moodCount: [:], sortedMoodName: [], sortedPercent: [])
    
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
        
        let selectDate = selectedDate.toString(of: .dateForChart)
        
        switch DateRange(rawValue: sender.tag) {
        case .daliy:
            data = moodRepository.fetch(dateRange: .daliy, selectedDate: selectedDate, completionHandler: { [weak self] startDate, endDate in
                self?.mainView.dateRangeLabel.text = startDate.toString(of: .dateForChart)
            })
        case .weekly:
            data = moodRepository.fetch(dateRange: .weekly, selectedDate: selectedDate, completionHandler: { [weak self] startDate, endDate in
                self?.mainView.dateRangeLabel.text = "\(startDate.toString(of: .dateForChart)) ~ " + selectDate
            })
        case .monthly:
            data = moodRepository.fetch(dateRange: .monthly, selectedDate: selectedDate, completionHandler: { [weak self] startDate, endDate in
                self?.mainView.dateRangeLabel.text = "\(startDate.toString(of: .dateForChart)) ~ " + selectDate
            })
        default: print("")
        }
        
        if data == [] {
            pieData = nil
            pieData?.notifyDataChanged()
            moodData = MoodData(moodCount: [:], sortedMoodName: [], sortedPercent: [])
        } else {
            pieData = setChartData(data: data ?? [])
            chartDataCount = data?.count ?? 0
        }
        
        mainView.chartTableView.reloadData()
    }
    
    func setChartData(data: [Mood]) -> PieChartData {
        let moodCounts = moodRepository.countMoods(moods: data)
        let allCount = data.count
        
        var moodEntries: [PieChartDataEntry] = []
        var colorSet: [UIColor] = []
        
        let sortedMoodCount = moodCounts.sorted { $0.value > $1.value }
        let count = sortedMoodCount.map { $0.value }
        let name = sortedMoodCount.map { $0.key }
        
        moodData.moodCount = moodCounts
        moodData.sortedPercent = count.map { Double($0) / Double(allCount) * 100 }
        moodData.sortedMoodName = name
        
        if count.count > 6 {
            let getFiveCount = Array(count.prefix(5))
            let getFiveName = Array(name.prefix(5))
            let etcCount = allCount - (getFiveCount.reduce(0) { $0 + $1 })
            
            getFiveCount.forEach {
                let value = (Double($0) / Double(allCount)) * 100
                let label = String(format: "%.1f", value) + "%"
                moodEntries.append(PieChartDataEntry(value: value, label: label))
            }
            
            let etc = getFiveCount.last ?? 1
            let etcResult = (Double(etc) / Double(allCount)) * 100
//            let etcResult = (Double(etcCount) / Double(allCount)) * 100
            
            moodEntries.append(PieChartDataEntry(value: etcResult, label: "기타")) //"기타\(String(format: "%.1f", etcResult))%"
            
            getFiveName.forEach { colorSet.append(UIColor(named: $0 + "_Background") ?? .lightGray) }
            colorSet.append(Constants.Color.Background.basic)
            
        } else {
            
            let value = count.map { Double($0) / Double(allCount) * 100 }
            value.forEach {
                let label = String(format: "%.1f", $0) + "%"
                moodEntries.append(PieChartDataEntry(value: $0, label: label))
            }
            
            name.forEach { colorSet.append(UIColor(named: $0 + "_Background") ?? .lightGray) }
        }
        
        let dataSet = PieChartDataSet(entries: moodEntries)
        dataSet.colors = colorSet
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
        switch section {
        case 0: return 1
        default: return moodData.sortedMoodName.count
        }
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
            
            let item = moodData.sortedMoodName[indexPath.item]
            
            cell.configureCell(item: item, moodData: moodData)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 320
        default: return 60
        }
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
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFromRealm = moodRepository.fetchAllDate()
        
        if dateFromRealm.contains(date) {
            return 1
        } else {
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        [Constants.Color.iconTint.unselected]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        [Constants.Color.iconTint.unselected]
    }
}
