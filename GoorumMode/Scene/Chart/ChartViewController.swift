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
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
        mainView.chartTableView.delegate = self
        mainView.chartTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.chartTableView.reloadData()
    }
    
    func setChartData() -> PieChartData {
        let data = MoodRepository.shared.fetch(selectedDate: Date())
        
        var moodCounts: [String: Int] = [:]
        for mood in data {
            let mood = mood.mood
            if moodCounts.keys.contains(mood) {
                moodCounts[mood] = (moodCounts[mood] ?? 0) + 1
            } else {
                moodCounts[mood] = 1
            }
        }
        
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
        
        let test = PieChartData(dataSet: dataSet)
        return test
    }
    
}

extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartTableViewCell.reuseIdentifier) as? ChartTableViewCell else { return UITableViewCell() }
        cell.pieChartView.data = setChartData()
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
