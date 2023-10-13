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
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MoodRepository.shared.checkFileURL()
        
        setNavigationBar()
        configureDataSource()

        viewModel.moods.bind { [weak self] moods in
            self?.updateSnapshot()
        }
        
        mainView.addMoodButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        mainView.collectionView.delegate = self
        
    }
    
    @objc func calendarBarbuttonClicked() {
        let vc = CalendarViewController()
        
        vc.modalPresentationStyle = .overFullScreen
        vc.completionHandler = { [weak self] date in
            self?.viewModel.moods.value = MoodRepository.shared.fetch(selectedDate: date)
            self?.title = date.toString(of: .dateForTitle)
            self?.selectedDate = date
        }
        present(vc, animated: false)
    }
    
    @objc func addButtonClicked() {
        
        let vc = AddViewController()
        let nav = UINavigationController(rootViewController: vc)

        vc.selectedDate = selectedDate
        vc.transtion = .add
        vc.completionHandler = { [weak self] data in
            self?.viewModel.moods.value.append(data)
            self?.viewModel.moods.value.sort(by: { $0.date > $1.date })
            
            if let item = self?.snapshot.indexOfItem(data) {
                let indexPath = IndexPath(item: item, section: 0)
                self?.mainView.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            }
            
        }
        
        present(nav, animated: true)
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
        }
        
        vc.removeData = { [weak self] in
            self?.viewModel.moods.value.remove(at: indexPath.item)
        }

        present(nav, animated: true)
        
    }
}

extension MoodViewController {
    
    func setNavigationBar() {
        title = Date().toString(of: .dateForTitle)
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Constants.Color.Text.basicSubTitle ?? .systemGray4,
            NSAttributedString.Key.font: Constants.Font.extraBold(size: 16)
        ]

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.IconImage.calendar, style: .plain, target: self, action: #selector(calendarBarbuttonClicked))
    }
}
