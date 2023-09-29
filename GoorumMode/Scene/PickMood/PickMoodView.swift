//
//  PickMoodView.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/29.
//

import UIKit

final class PickMoodView: BaseView {
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.register(PickMoodCollectionViewCell.self, forCellWithReuseIdentifier: PickMoodCollectionViewCell.identifier)
        view.backgroundColor = Constants.Color.Background.basic
        return view
    }()
    
    override func configure() {
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 35, bottom: 20, trailing: 35)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
