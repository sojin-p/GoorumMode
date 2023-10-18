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
    
    var selectedDate = Date()
    
    let moodRepository = MoodRepository()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        moodRepository.checkFileURL()
        
        setNavigationBar()
        setPlaceholder()
        configureDataSource()

        viewModel.moods.bind { [weak self] moods in
            self?.updateSnapshot()
        }
        
        mainView.addMoodButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        mainView.collectionView.delegate = self
        
    }
    
    @objc func settingBarbuttonClicked() {
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func calendarBarbuttonClicked() {
        let vc = CalendarViewController()
        
        vc.completionHandler = { [weak self] date in
            self?.viewModel.moods.value = self?.moodRepository.fetch(dateRange: .daliy, selectedDate: date) ?? []
            self?.mainView.dateLabel.text = date.toString(of: .dateForTitle)
            self?.mainView.dateLabel.sizeToFit()
            self?.selectedDate = date
            self?.setPlaceholder()
        }
        vc.selectedDate = selectedDate
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addButtonClicked() {
        
        let vc = AddViewController()
        let nav = UINavigationController(rootViewController: vc)

        vc.selectedDate = selectedDate
        vc.transtion = .add
        vc.completionHandler = { [weak self] data in
            self?.viewModel.moods.value.append(data)
            self?.viewModel.moods.value.sort(by: { $0.date > $1.date })
            self?.scrollToItem(data: data)
            self?.setPlaceholder()
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
        
        dataSource.apply(snapshot)
        
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
                cell.detailBackView.isHidden = true
            } else {
                cell.detailLabel.text = itemIdentifier.detailText
                cell.detailBackView.isHidden = false
            }
            cell.detailLabel.setLineSpacing(spacing: 5)
            
            let timeAccessibilityLabel = itemIdentifier.date.toString(of: .timeForAccessibility)
            let moodAccessibilityLabel = MoodEmojis(rawValue: itemIdentifier.mood)?.accessLabel ?? "기분"
            cell.accessibilityLabel = "\(timeAccessibilityLabel) 기록함, \(moodAccessibilityLabel) 이미지, 한 줄 내용, \(cell.onelineLabel.text ?? "없음"), 자세한 내용, \(cell.detailLabel.text ?? "없음")"
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
        vc.selectedDate = selectedDate
        
        vc.completionHandler = { [weak self] data in
            self?.viewModel.moods.value[indexPath.item] = data
            self?.viewModel.moods.value.sort(by: { $0.date > $1.date })
            self?.scrollToItem(data: data)
        }
        
        vc.removeData = { [weak self] in
            self?.viewModel.moods.value.remove(at: indexPath.item)
            self?.setPlaceholder()
        }

        present(nav, animated: true)
        
    }
}

extension MoodViewController {
    
    func setNavigationBar() {
        navigationItem.titleView = mainView.dateLabel
        let calendarBarButton = UIBarButtonItem(image: Constants.IconImage.calendar, style: .plain, target: self, action: #selector(calendarBarbuttonClicked))
        calendarBarButton.accessibilityLabel = "달력"
        calendarBarButton.accessibilityHint = "다른 날의 기록을 보려면 두 번 탭 하세요."
        navigationItem.leftBarButtonItem = calendarBarButton
        
        let settingBarButton = UIBarButtonItem(image: Constants.IconImage.setting, style: .plain, target: self, action: #selector(settingBarbuttonClicked))
        settingBarButton.accessibilityLabel = "설정"
//        settingBarButton.accessibilityHint = "언어, 테마 등을 설정하려면 두 번 탭 하세요."
        navigationItem.rightBarButtonItem = settingBarButton
    }
    
    func setPlaceholder() {
        if viewModel.moods.value.isEmpty {
            mainView.collectionViewPlaceholder.isHidden = false
        } else {
            mainView.collectionViewPlaceholder.isHidden = true
        }
    }
}
