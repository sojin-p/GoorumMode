//
//  ViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/19.
//

import UIKit

final class MoodViewController: BaseViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Mood>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, Mood>!
    
    private let mainView = MoodView()
    private let viewModel = MoodViewModel()
    private let moodRepository = MoodRepository()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        moodRepository.checkFileURL()
        
        setNavigationBar()
        configureDataSource()
        setMoodBind()
        
        mainView.addMoodButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        mainView.collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBind()
    }
    
    @objc private func searchBarButtonClicked() {
        let vc = SearchViewController()
        
        vc.completionHandler = { [weak self] data in
            DateManager.shared.selectedDate.value = data.date
            self?.viewModel.fetchSelectedDate(data.date)
            DispatchQueue.main.async {
                self?.scrollToItem(data: data)
            }
        }
        
        navigationController?.pushViewController(vc, animated: false)
    }

    @objc private func calendarBarbuttonClicked() {
        let vc = CalendarViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func addButtonClicked() {
        
        let vc = AddViewController()
        let nav = UINavigationController(rootViewController: vc)

        vc.transtion = .add
        vc.completionHandler = { [weak self] data in
            self?.viewModel.append(data)
            DispatchQueue.main.async {
                self?.scrollToItem(data: data)
            }
        }
        
        present(nav, animated: true)
    }
    
    private func scrollToItem(data: Mood) {
        if let item = snapshot.indexOfItem(data) {
            let indexPath = IndexPath(item: item, section: 0)
            mainView.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }
    }
}

// MARK: - DataSource, Snapshot
extension MoodViewController {
    
    private func updateSnapshot() {
        snapshot = NSDiffableDataSourceSnapshot<Section, Mood>()
        snapshot.appendSections([.today])
        snapshot.appendItems(viewModel.moods.value)
        
        dataSource.applySnapshotUsingReloadData(snapshot)

    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<MoodCollectionViewCell, Mood>(handler: { cell, indexPath, itemIdentifier in
            
            cell.configureCell(itemIdentifier, dateType: .timeWithoutSecond)
            cell.setCellAccessibility(itemIdentifier, accessibilityDateType: .timeForAccessibility)
            cell.accessibilityHint = "modify_AccessibilityHint".localized
            
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
            DispatchQueue.main.async {
                self?.scrollToItem(data: data)
            }
        }
        
        vc.removeData = { [weak self] in
            self?.viewModel.remove(idx: indexPath.item)
        }

        present(nav, animated: true)
        
    }
}

extension MoodViewController {
    
    private func setNavigationBar() {
        navigationItem.titleView = mainView.dateLabel
        
        let calendarBarButton = UIBarButtonItem(image: Constants.IconImage.calendar, style: .plain, target: self, action: #selector(calendarBarbuttonClicked))
        calendarBarButton.accessibilityLabel = "calendarBarButton_AccessibilityLabel".localized
        calendarBarButton.accessibilityHint = "calendarBarButton_AccessibilityHint".localized
        navigationItem.leftBarButtonItem = calendarBarButton
        
//        settingButton.accessibilityLabel = "settingBarButton_AccessibilityLabel".localized
//        settingButton.accessibilityHint = "settingBarButton.accessibilityHint".localized
        
        let searchImage = Constants.IconImage.search
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: searchImage.size.width, height: searchImage.size.height))
        searchButton.tintColor = Constants.Color.iconTint.basicBlack
        searchButton.setImage(searchImage, for: .normal)
        searchButton.addTarget(self, action: #selector(searchBarButtonClicked), for: .touchUpInside)
        searchButton.accessibilityLabel = "searchBarButton_AccessibilityLabel".localized
        searchButton.accessibilityHint = "searchBarButton.accessibilityHint".localized
        
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        navigationItem.rightBarButtonItems = [searchBarButton]
    }
    
    private func setPlaceholder() {
        if viewModel.moods.value.isEmpty {
            mainView.collectionViewPlaceholder.isHidden = false
        } else {
            mainView.collectionViewPlaceholder.isHidden = true
        }
    }
    
    private func setMoodBind() {
        viewModel.moods.bind { [weak self] moods in
            DispatchQueue.main.async {
                self?.updateSnapshot()
                self?.setPlaceholder()
            }
        }
    }
    
    private func setBind() {
        
        DateManager.shared.selectedDate.bind { [weak self] date in
            print("===MoodVC date bind: ", date)
            self?.viewModel.fetchSelectedDate(date)
            DispatchQueue.main.async {
                self?.mainView.dateLabel.text = date.toString(of: .dateForTitle)
                self?.mainView.dateLabel.sizeToFit()
            }
        }
        
    }
}
