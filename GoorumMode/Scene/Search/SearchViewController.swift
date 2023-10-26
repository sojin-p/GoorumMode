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
        view.searchTextField.placeholder = "search_placeholder".localized
        view.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        view.searchTextField.backgroundColor = UIColor.clear
        return view
    }()
    
    let moodView = MoodView()
    let moodRepository = MoodRepository()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Mood>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, Mood>!
    
    var results: [Mood] = []
    var completionHandler: ((Mood) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = [NSAttributedString.Key.font: Constants.Font.regular(size: 15)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
        
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.isEmpty {
            showAlert(title: "alert_searchTextIsEmpty".localized, massage: nil)
        } else if results.isEmpty {
            showAlert(title: "alert_searchResultsIsEmpty".localized, massage: nil)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        results = moodRepository.search(text: searchText)
        updateSnapshot()
    }
   
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedData = dataSource.itemIdentifier(for: indexPath) else { return }
        
        showAlertWithAction(
            title: "alert_MoveSelectedDate".localized, message: nil,
            buttonName: "alert_OKButtonTitle".localized,
            buttonStyle: .default) {
                self.completionHandler?(selectedData)
                self.navigationController?.popViewController(animated: true)
            }
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
            
            cell.configureCell(itemIdentifier, dateType: .detailedDate)
            
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: moodView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
    }
}
