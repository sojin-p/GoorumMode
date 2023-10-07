//
//  ViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/19.
//

import UIKit

final class MoodViewController: BaseViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Mood>!
    
    let mainView = MoodView()
    
    let viewModel = MoodViewModel()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()

        viewModel.moods.bind { [weak self] moods in
            print("리스트 바뀜")
            self?.updateSnapshot()
        }
        
        mainView.addMoodButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        MoodRepository.shared.checkFileURL()
        
        mainView.collectionView.delegate = self
        
    }
    
    @objc func addButtonClicked() {
        
        let vc = AddViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        vc.transtion = .add
        vc.completionHandler = { [weak self] data in
            self?.mainView.collectionView.scroll(to: .top)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self?.viewModel.moods.value.insert(data, at: 0)
            }
        }
        
        present(nav, animated: true)
    }

}

// MARK: - DataSource, Snapshot
extension MoodViewController {
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Mood>()
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
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: Section.today.header) { supplementaryView, elementKind, indexPath in
            supplementaryView.label.text = elementKind
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return self.mainView.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
    }
}

extension MoodViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = AddViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        let item = viewModel.moods.value[indexPath.item]
        
        vc.transtion = .modify
        vc.moods = item

        vc.completionHandler = { [weak self] data in
            self?.viewModel.moods.value[indexPath.item] = data
        }
        
        vc.removeData = { [weak self] in
            self?.viewModel.moods.value.remove(at: indexPath.item)
        }

        present(nav, animated: true)
        
    }
}
