//
//  ViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/19.
//

import UIKit

final class MoodViewController: BaseViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    let list = ["gkgk", "asdasf", "fdnsdgfsdfdsf", "ㄴㅇㄹㅇㄴㄹㄴㅇㅎ", "ㅁㄴㅇㄹㄴㅇㄴ"]
    
    let mainView = MoodView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.setupAccessibilityLabel()
        configureDataSource()
        updateSnapshot()
        
        mainView.addMoodButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    }
    
    @objc func addButtonClicked() {
        print("클릭")
    }

}

// MARK: - DataSource, Snapshot
extension MoodViewController {
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.today])
        snapshot.appendItems(list)
        
        dataSource.apply(snapshot)
        
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<MoodCollectionViewCell, String>(handler: { cell, indexPath, itemIdentifier in
            cell.moodImageView.image = UIImage(systemName: "star")
            cell.onelineLabel.text = itemIdentifier
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
