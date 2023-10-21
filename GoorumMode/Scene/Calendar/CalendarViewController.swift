//
//  CalendarViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/07.
//

import UIKit
import FSCalendar

final class CalendarViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    var calendar = {
        let view = BasicFSCalendar()
        view.headerHeight = 60
        view.appearance.headerTitleFont = Constants.Font.extraBold(size: 18)
        view.accessibilityElementsHidden = true
        return view
    }()
    
    private let headerView = {
        let view = CalendarHeaderView()
        return view
    }()
    
    let showDateButton = {
        let view = CapsulePaddingButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30), title: "showDateButton_Title".localized)
        view.tintColor = Constants.Color.iconTint.basicBlack
        view.isSelected = true
        view.backgroundColor = Constants.Color.Background.white
        view.buttonShadow(radius: 3, opacity: 0.5)
        view.accessibilityElementsHidden = true
        return view
    }()
    
    var completionHandler: ((Date) -> Void)?
    var selectedDate: Date?
    lazy var currentDate = calendar.currentPage
    var isShowed = false
    let moodRepository = MoodRepository()
    
    deinit {
        print("캘린더 사라짐")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        setAccessibility(selectedDate)
        
        calendar.select(selectedDate)
        headerView.headerLabel.text = selectedDate?.toString(of: .yearAndMouth)
        
        calendar.delegate = self
        calendar.dataSource = self
        
        showDateButton.addTarget(self, action: #selector(showDateButtonClicked), for: .touchUpInside)
        headerView.backTodayButton.addTarget(self, action: #selector(backTodayButtonClicked), for: .touchUpInside)
        headerView.showMonthButton.addTarget(self, action: #selector(showMonthButtonClicked), for: .touchUpInside)
        headerView.headerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMonthButtonClicked)))
        
        calendar.calendarHeaderView.accessibilityElementsHidden = true
        
        setNavigationBackBarButton()
        navigationController?.interactivePopGestureRecognizer?.delegate = self

    }
    
    func setAccessibility(_ selectedDate: Date?) {
        guard let selectedDate = selectedDate else { return }
        let date = Calendar.current.startOfDay(for: selectedDate)
        let mostMoods = getMostMood(date: date)
        
        let isEmptyString = "cellRegistration_AccessibilityLabel_isEmpty".localized
        
        let moodName = mostMoods[date] ?? isEmptyString
        let selectedMood = MoodEmojis(rawValue: moodName)?.accessLabel ?? isEmptyString
        let selectedDateAccessLabel = date.toString(of: .dateForTitle)
        
        let value = NSLocalizedString("mostMood_AccessibilityLabel", comment: "")
        headerView.headerLabel.accessibilityLabel = String(format: value, "\(selectedDateAccessLabel)", "\(selectedMood)")
        headerView.headerLabel.accessibilityHint = "headerLabel_AccessibilityHint".localized
    }

    @objc private func showMonthButtonClicked() {
        let vc = SelectDateViewController()
        
        let selectedDay = Calendar.current.component(.day, from: selectedDate ?? Date())
        var dateComponents = DateComponents()
        dateComponents.day = selectedDay - 1
        
        if let willPassDate = Calendar.current.date(byAdding: dateComponents, to: currentDate) {
            vc.selectedDate = willPassDate
        }
        
        vc.completionHandler = { [weak self] date in
            self?.calendar.select(date)
            self?.selectedDate = date
            self?.setAccessibility(date)
        }
        
        present(vc, animated: true)
    }
    
    @objc func showDateButtonClicked() {
        isShowed.toggle()
        if isShowed {
            if selectedDate != Calendar.current.startOfDay(for: Date()) {
                calendar.appearance.todayColor = .clear
            }
            showDateButton.setTitle("showDateButton_isSelected_Title".localized, for: .normal)
        } else {
            showDateButton.setTitle("showDateButton_Title".localized, for: .normal)
        }
        calendar.reloadData()
    }
    
    @objc private func backTodayButtonClicked() {
        calendar.select(Date())
        selectedDate = Date()
    }
    
    override func configure() {
        super.configure()
        calendar.register(FSCalendarCustomCell.self, forCellReuseIdentifier: FSCalendarCustomCell.reuseIdentifier)
        [calendar, headerView, showDateButton].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        
        calendar.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-35)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
        }
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(calendar.calendarHeaderView)
            make.top.trailing.equalTo(calendar)
            make.leading.equalTo(calendar).offset(-7)
        }
        
        showDateButton.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(10)
            make.centerX.equalTo(calendar)
            make.height.equalTo(30)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false)
    }

    func getMostMood(date: Date) -> [Date: String] {
        
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let moodsForMonth = moodRepository.fetchMonth(year: year, month: month)
        
        let groupedMoods = Dictionary(grouping: moodsForMonth) { Calendar.current.startOfDay(for: $0.date) }
        
        var mostMoods: [Date: String] = [:]
        
        for (date, moods) in groupedMoods {
            let moodCounts = moodRepository.countMoods(moods: moods)
            
            var maxKeys: [String] = []
            if let maxValue = moodCounts.values.max() {
                maxKeys = moodCounts.filter({ $0.value == maxValue }).map({ $0.key })
            }
            
            if maxKeys.count == 1 {
                mostMoods[date] = maxKeys.first
            } else {
                if let recentMood = moods.max(by: { $0.date < $1.date })?.mood {
                    mostMoods[date] = recentMood
                }
            }
        }
        
        return mostMoods
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.reloadData()
        currentDate = calendar.currentPage
        headerView.headerLabel.text = currentDate.toString(of: .yearAndMouth)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: FSCalendarCustomCell.reuseIdentifier, for: date, at: position) as? FSCalendarCustomCell else { return FSCalendarCell() }
        
        if !isShowed {
            
            let mostMoods: [Date: String] = getMostMood(date: date)
            
            if mostMoods.keys.contains(date) {
                cell.moodImageView.image = UIImage(named: mostMoods[date] ?? MoodEmojis.placeholder)
            }
            
        }
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if date != Calendar.current.startOfDay(for: Date()) {
            calendar.appearance.todayColor = .clear
        }
        completionHandler?(date)
        navigationController?.popViewController(animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
