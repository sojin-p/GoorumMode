//
//  ViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/19.
//

import UIKit

final class MoodViewController: BaseViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Mood>!
    
    var moods: [Mood] = [
        Mood(mood: MoodEmojis.tired.rawValue, date: Date(), onelineText: "코딩함", detailText: "오늘은 무엇무엇을 했다. 어쩌구 저쩌구를 했는데 나쁘지않았다. 오늘 CRUD를 만들었어야 했는데 값 전달이랑, 다른 이슈 등을 해결하다보니 오늘 하루가 다 갔다. 언제쯤 CRUD에 들어갈 수 있을까?", image: ""),
        Mood(mood: MoodEmojis.neutral.rawValue, date: Date(), onelineText: "", detailText: "", image: "")
    ]
    
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
        
        let vc = AddViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        vc.completionHandler = { [weak self] data in
            self?.moods.append(data)
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
