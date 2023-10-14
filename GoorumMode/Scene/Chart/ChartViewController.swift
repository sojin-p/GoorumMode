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
    var data: [Mood] = []
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for button in mainView.chartButtons {
            if button.isSelected {
                chartButtonClicked(button)
            }
        }
    }
    
    @objc func chartButtonClicked(_ sender: UIButton) {
        
        switch DateRange(rawValue: sender.tag) {
        case .daliy:
            data = MoodRepository.shared.fetch(dateRange: .daliy, selectedDate: selectedDate)
        case .weekly:
            data = MoodRepository.shared.fetch(dateRange: .weekly, selectedDate: selectedDate)
        case .monthly:
            data = MoodRepository.shared.fetch(dateRange: .monthly, selectedDate: selectedDate)
        default: print("")
        }
        
        pieData = setChartData(data: data)
        mainView.chartTableView.reloadData()
        
    }
    
    func setChartData(data: [Mood]) -> PieChartData {
        let moodCounts = MoodRepository.shared.countMoods(moods: data)
        
        var moodStatsResults: [String : Double] = [:]
        let allCount = data.count
        
        var moodEntries: [PieChartDataEntry] = []
        var colorSet: [UIColor] = []
        
        for (mood, count) in moodCounts {
            moodStatsResults[mood] = (Double(count) / Double(allCount)) * 100
            let icon = NSUIImage(named: mood)?.downSample(scale: view, size: CGSize(width: 10, height: 10))
            moodEntries.append(PieChartDataEntry(value: moodStatsResults[mood] ?? 0, icon: icon))
            colorSet.append(UIColor(named: mood + "_Background") ?? .blue)
        }
        
        let dataSet = PieChartDataSet(entries: moodEntries)
        dataSet.colors = colorSet
        dataSet.drawIconsEnabled = true
        dataSet.iconsOffset = CGPoint(x: 0, y: 30)
        dataSet.valueTextColor = .darkGray
        dataSet.valueFont = Constants.Font.extraBold(size: 14)
        dataSet.selectionShift = 5
        
        return PieChartData(dataSet: dataSet)
    }
    
}

extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.reuseIdentifier) as? ChartTableViewCell else { return UITableViewCell() }
        cell.pieChartView.data = pieData
        cell.selectionStyle = .none
        return cell
    }
}

extension ChartViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentDate = calendar.currentPage
        mainView.headerLabel.text = currentDate.toString(of: .yearAndMouth)
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
