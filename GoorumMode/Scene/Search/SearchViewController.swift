//
//  SearchViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/24.
//

import UIKit
import RealmSwift

final class SearchViewController: BaseViewController {
    
    private let searchBar = {
        let view = UISearchBar()
        view.searchTextField.placeholder = "search_placeholder".localized
        view.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        view.searchTextField.backgroundColor = UIColor.clear
        return view
    }()
    
    private let moodView = MoodView()
    private let moodRepository = MoodRepository()
    
    private typealias MoodID = ObjectId
    private var dataSource: UICollectionViewDiffableDataSource<Section, MoodID>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, MoodID>!
    
    private var results: [MoodID] = []
    var completionHandler: ((Mood) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = [NSAttributedString.Key.font: Constants.Font.regular(size: 15)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
        
        moodView.collectionView.keyboardDismissMode = .onDrag
        moodView.collectionView.delegate = self
        
        setNavigationBackBarButton()
        
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        
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
            AlertManager.shared.showAlert(on: self, title: "alert_searchTextIsEmpty".localized)
        } else if results.isEmpty {
            AlertManager.shared.showAlert(on: self, title: "alert_searchResultsIsEmpty".localized)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let moods = moodRepository.search(text: searchText)
        results = moods.map { $0._id }
        updateSnapshot()
    }
   
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectedId = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let selectedMood = fetchMood(by: selectedId) else { return }
        
        AlertManager.shared.showAlertWithAction(
            on: self,
            title: "alert_MoveSelectedDate".localized,
            buttonName: "alert_OKButtonTitle".localized,
            buttonStyle: .default) { [weak self] in
                DateManager.shared.selectedDate.value = selectedMood.date
                self?.completionHandler?(selectedMood)
                self?.navigationController?.popViewController(animated: true)
        }
        
    }
}

extension SearchViewController {
    
    private func updateSnapshot() {
        snapshot = NSDiffableDataSourceSnapshot<Section, MoodID>()
        snapshot.appendSections([.today])
        snapshot.appendItems(results)
        
        dataSource.applySnapshotUsingReloadData(snapshot)

    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<MoodCollectionViewCell, MoodID>(
            handler: { [weak self] cell, indexPath, itemIdentifier in
                guard
                    let self,
                    let mood = self.fetchMood(by: itemIdentifier) //MoodId -> Mood 변환
                else { return }

            cell.configureCell(mood, dateType: .detailedDate)
            cell.setCellAccessibility(mood, accessibilityDateType: .dateForAccessibility)
            cell.accessibilityHint = "search_AccessibilityHint".localized
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: moodView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
    }
    
    private func fetchMood(by id: ObjectId) -> Mood? {
        do {
            let realm = try Realm()
            return realm.object(ofType: Mood.self, forPrimaryKey: id)
        } catch {
            return nil
        }
    }
}
