//
//  CalendarViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/07.
//

import UIKit
import FSCalendar

final class CalendarViewController: BaseViewController {
    
    private var calendar = {
        let view = BasicFSCalendar()
        view.headerHeight = 60
        view.appearance.headerTitleFont = Constants.Font.extraBold(size: 18)
        view.accessibilityElementsHidden = true
        return view
    }()
    
    private let headerView = {
        let view = CalendarHeaderView()
        view.backgroundColor = Constants.Color.Background.calendar
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
    
    private let viewModel = CalendarViewModel()
    
    var selectedDate = DateManager.shared.selectedDate.value
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setbind()
        setUI()
        setAccessibility(selectedDate)
        setNavigationBackBarButton()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateBind()
        
    }

    @objc private func showMonthButtonClicked() {
        let vc = SelectDateViewController()
        
        vc.completionHandler = { [weak self] date in
            DateManager.shared.selectedDate.value = date
            self?.setAccessibility(date)
        }
        
        present(vc, animated: true)
    }
    
    @objc private func showDateButtonClicked() {
        viewModel.showDateButtonClicked(selectedDate: selectedDate, calendar: calendar)
    }
    
    @objc private func backTodayButtonClicked() {
        DateManager.shared.selectedDate.value = Date()
    }
    
    override func configure() {
        view.backgroundColor = Constants.Color.Background.calendar
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
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        headerView.headerLabel.text = calendar.currentPage.toString(of: .yearAndMouth)
        
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: FSCalendarCustomCell.reuseIdentifier, for: date, at: position) as? FSCalendarCustomCell else { return FSCalendarCell() }
        
        if !viewModel.isShowed.value {
            
            let mostMoods: [Date: String] = viewModel.getMostMood(date: date)
            
            if mostMoods.keys.contains(date) {
                cell.moodImageView.image = UIImage(named: mostMoods[date] ?? MoodEmojis.placeholder)
            }
            
        }
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        DateManager.shared.selectedDate.value = date
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

extension CalendarViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
    
    private func setUI() {
        calendar.select(selectedDate)
        
        if selectedDate != Calendar.current.startOfDay(for: Date()) {
            calendar.appearance.todayColor = .clear
        }
        
        calendar.delegate = self
        calendar.dataSource = self
        
        showDateButton.addTarget(self, action: #selector(showDateButtonClicked), for: .touchUpInside)
        headerView.backTodayButton.addTarget(self, action: #selector(backTodayButtonClicked), for: .touchUpInside)
        headerView.showMonthButton.addTarget(self, action: #selector(showMonthButtonClicked), for: .touchUpInside)
        headerView.headerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMonthButtonClicked)))
        
        calendar.calendarHeaderView.accessibilityElementsHidden = true
    }
        
    private func setbind() {
        
        viewModel.isShowed.bind { [weak self] bool in
            if bool {
                self?.showDateButton.setTitle("showDateButton_isSelected_Title".localized, for: .normal)
            } else {
                self?.showDateButton.setTitle("showDateButton_Title".localized, for: .normal)
            }
        }
    }
    
    private func dateBind() {
        DateManager.shared.selectedDate.bind { [weak self] date in
            print("===datemanager bind: ", date)
            DispatchQueue.main.async {
                self?.headerView.headerLabel.text = date.toString(of: .yearAndMouth)
                self?.calendar.select(date)
                self?.calendar.reloadData()
            }
        }
    }
    
    private func setAccessibility(_ selectedDate: Date?) {
        guard let selectedDate = selectedDate else { return }
        let date = Calendar.current.startOfDay(for: selectedDate)
        let mostMoods = viewModel.getMostMood(date: date)
        
        let isEmptyString = "cellRegistration_AccessibilityLabel_isEmpty".localized
        
        let moodName = mostMoods[date] ?? isEmptyString
        let selectedMood = MoodEmojis(rawValue: moodName)?.accessLabel ?? isEmptyString
        let selectedDateAccessLabel = date.toString(of: .dateForTitle)
        
        let value = NSLocalizedString("mostMood_AccessibilityLabel", comment: "")
        headerView.headerLabel.accessibilityLabel = String(format: value, "\(selectedDateAccessLabel)", "\(selectedMood)")
        headerView.headerLabel.accessibilityHint = "headerLabel_AccessibilityHint".localized
    }
}
