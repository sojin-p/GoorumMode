//
//  ViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/19.
//

import UIKit

final class MoodViewController: BaseViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Mood>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, Mood>!
    
    let mainView = MoodView()
    let viewModel = MoodViewModel()
    let moodRepository = MoodRepository()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        moodRepository.checkFileURL()
        
        setNavigationBar()
        configureDataSource()
        setBind()
        
        mainView.addMoodButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        mainView.collectionView.delegate = self
        
    }
    
    @objc func settingBarbuttonClicked() {
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func calendarBarbuttonClicked() {
        let vc = CalendarViewController()
        
        vc.selectedDate = viewModel.selectedDate.value
        vc.completionHandler = { [weak self] date in
            self?.viewModel.fetchSelectedDate(date)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addButtonClicked() {
        
        let vc = AddViewController()
        let nav = UINavigationController(rootViewController: vc)

        vc.selectedDate = viewModel.selectedDate.value
        vc.transtion = .add
        vc.completionHandler = { [weak self] data in
            self?.viewModel.append(data)
            self?.scrollToItem(data: data)
        }
        
        present(nav, animated: true)
    }
    
    func scrollToItem(data: Mood) {
        if let item = snapshot.indexOfItem(data) {
            let indexPath = IndexPath(item: item, section: 0)
            mainView.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }
    }
}

// MARK: - DataSource, Snapshot
extension MoodViewController {
    
    func updateSnapshot() {
        snapshot = NSDiffableDataSourceSnapshot<Section, Mood>()
        snapshot.appendSections([.today])
        snapshot.appendItems(viewModel.moods.value)
        
        dataSource.applySnapshotUsingReloadData(snapshot)

    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<MoodCollectionViewCell, Mood>(handler: { cell, indexPath, itemIdentifier in
            
            cell.moodImageView.image = UIImage(named: itemIdentifier.mood)
            cell.timeLabel.text = itemIdentifier.date.toString(of: .timeWithoutSecond)
            
            if let onelineText = itemIdentifier.onelineText, onelineText.isEmpty {
                cell.onelineLabel.isHidden = true
            } else {
                cell.onelineLabel.text = itemIdentifier.onelineText
                cell.onelineLabel.isHidden = false
            }
            
            if let detailText = itemIdentifier.detailText, detailText.isEmpty {
                cell.detailLabel.isHidden = true
            } else {
                cell.detailLabel.text = itemIdentifier.detailText
                cell.detailLabel.isHidden = false
            }
            
            cell.detailLabel.setLineSpacing(spacing: 5)
            
            let isEmptyString = "cellRegistration_AccessibilityLabel_isEmpty".localized
            let timeAccessibilityLabel = itemIdentifier.date.toString(of: .timeForAccessibility)
            let moodAccessibilityLabel = MoodEmojis(rawValue: itemIdentifier.mood)?.accessLabel ?? isEmptyString
            
            let value = NSLocalizedString("cellRegistration_AccessibilityLabel", comment: "")
            cell.accessibilityLabel = String(format: value, "\(timeAccessibilityLabel)", "\(moodAccessibilityLabel)", "\(cell.onelineLabel.text ?? isEmptyString)", "\(cell.detailLabel.text ?? isEmptyString)")
            
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
    }
}

extension MoodViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = AddViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        let item = viewModel.moods.value[indexPath.item]
        
        vc.transtion = .modify
        vc.moods = item
        vc.selectedDate = viewModel.selectedDate.value
        
        vc.completionHandler = { [weak self] data in
            self?.viewModel.update(idx: indexPath.item, data: data)
            self?.scrollToItem(data: data)
        }
        
        vc.removeData = { [weak self] in
            self?.viewModel.remove(idx: indexPath.item)
        }

        present(nav, animated: true)
        
    }
}

extension MoodViewController {
    
    func setNavigationBar() {
        navigationItem.titleView = mainView.dateLabel
        
        let calendarBarButton = UIBarButtonItem(image: Constants.IconImage.calendar, style: .plain, target: self, action: #selector(calendarBarbuttonClicked))
        calendarBarButton.accessibilityLabel = "calendarBarButton_AccessibilityLabel".localized
        calendarBarButton.accessibilityHint = "calendarBarButton_AccessibilityHint".localized
        navigationItem.leftBarButtonItem = calendarBarButton
        
        let settingBarButton = UIBarButtonItem(image: Constants.IconImage.setting, style: .plain, target: self, action: #selector(settingBarbuttonClicked))
        settingBarButton.accessibilityLabel = "settingBarButton_AccessibilityLabel".localized
//        settingBarButton.AccessibilityHint = "settingBarButton.accessibilityHint".localized
        navigationItem.rightBarButtonItem = settingBarButton
    }
    
    func setPlaceholder() {
        if viewModel.moods.value.isEmpty {
            mainView.collectionViewPlaceholder.isHidden = false
        } else {
            mainView.collectionViewPlaceholder.isHidden = true
        }
    }
    
    func setBind() {
        viewModel.moods.bind { [weak self] moods in
            DispatchQueue.main.async {
                self?.updateSnapshot()
                self?.setPlaceholder()
            }
        }
        
        viewModel.selectedDate.bind { [weak self] date in
            DispatchQueue.main.async {
                self?.mainView.dateLabel.text = date.toString(of: .dateForTitle)
                self?.mainView.dateLabel.sizeToFit()
            }
        }
    }
}
