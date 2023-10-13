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
        mainView.previousButton.addTarget(self, action: #selector(previousButtonClicked), for: .touchUpInside)
        mainView.nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
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
        
        for (mood, count) in moodCounts {
            moodStatsResults[mood] = round((Double(count) / Double(allCount) * 100))
            moodEntries.append(PieChartDataEntry(value: moodStatsResults[mood] ?? 0.0, label: mood))
        }
        
        print("====",moodStatsResults)
        
        let dataSet = PieChartDataSet(entries: moodEntries)
        let test = PieChartData(dataSet: dataSet)
        mainView.pieChartView.data = test
    }
    
    @objc func previousButtonClicked() {

    }
    
    @objc func nextButtonClicked() {
        
    }
    
}

extension ChartViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        mainView.calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
}
