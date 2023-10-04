//
//  ViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/19.
//

import UIKit
import RealmSwift

final class MoodViewController: BaseViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Mood>!
    
    var moodResults: Results<Mood>!
    lazy var moods = moodResults.toArray()
    
    let mainView = MoodView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        moodResults = MoodRepository.shared.fetch()
        
        mainView.setupAccessibilityLabel()
        configureDataSource()
        updateSnapshot()
        
        mainView.addMoodButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        MoodRepository.shared.checkFileURL()
        
    }
    
    @objc func addButtonClicked() {
        
        let vc = AddViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        vc.completionHandler = { [weak self] data in
            self?.moods.insert(data, at: 0)
            self?.updateSnapshot()
        }
        
        present(nav, animated: true)
    }

}

// MARK: - DataSource, Snapshot
extension MoodViewController {
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Mood>()
        snapshot.appendSections([.today])
        snapshot.appendItems(moods)
        
        dataSource.apply(snapshot)
        
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<MoodCollectionViewCell, Mood>(handler: { cell, indexPath, itemIdentifier in
            
            cell.moodImageView.image = UIImage(named: itemIdentifier.mood)
            cell.timeLabel.text = itemIdentifier.date.toString(of: .timeWithoutSecond)
            
            if let onelineText = itemIdentifier.onelineText, onelineText.isEmpty {
                cell.onelineLabel.isHidden = true
            }
            cell.onelineLabel.text = itemIdentifier.onelineText
            
            if let detailText = itemIdentifier.detailText, detailText.isEmpty {
                cell.detailBackView.isHidden = true
            }
            
            cell.detailLabel.text = itemIdentifier.detailText
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
