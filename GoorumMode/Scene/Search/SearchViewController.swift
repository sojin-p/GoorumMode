//
//  SearchViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/24.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    let searchBar = {
        let view = UISearchBar()
//        view.searchTextField.font = Constants.Font.regular(size: 15)
        view.searchTextField.placeholder = "일기 내용을 검색해 보세요"
        view.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        view.searchTextField.backgroundColor = UIColor.clear
        return view
    }()
    
    let moodView = MoodView()
    let moodRepository = MoodRepository()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Mood>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, Mood>!
    
    var results: [Mood] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moodView.collectionView.keyboardDismissMode = .onDrag
        moodView.collectionView.delegate = self
        
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        searchBar.delegate = self

        setNavigationBackBarButton()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        configureDataSource()
        updateSnapshot()
    }
    
    override func configure() {
        super.configure()
        view.addSubview(moodView.collectionView)

    }
    
    override func setConstraints() {
        moodView.collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate, UIGestureRecognizerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        results = moodRepository.search(text: searchText)
        updateSnapshot()
    }
   
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("알림 띄우고 확인누르면 dismiss 후 해당 날짜로")
        let selectedData = dataSource.itemIdentifier(for: indexPath)
        print("========", selectedData)
    }
}

extension SearchViewController {
    
    func updateSnapshot() {
        snapshot = NSDiffableDataSourceSnapshot<Section, Mood>()
        snapshot.appendSections([.today])
        snapshot.appendItems(results)
        
        dataSource.applySnapshotUsingReloadData(snapshot)

    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<MoodCollectionViewCell, Mood>(handler: { cell, indexPath, itemIdentifier in
            
            cell.moodImageView.image = UIImage(named: itemIdentifier.mood)
            cell.timeLabel.text = itemIdentifier.date.toString(of: .detailedDate)
            
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
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: moodView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
    }
}
