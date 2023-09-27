//
//  MoodView.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/26.
//

import UIKit

final class MoodView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    let addMoodButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        DispatchQueue.main.async {
            view.setImage(image, for: .normal)
            view.tintColor = Constants.Color.iconTint.basic
            view.backgroundColor = Constants.Color.Background.basicIcon
            view.layer.cornerRadius = view.frame.width / 2
        }
        view.accessibilityLabel = "추가 버튼입니다."
        view.accessibilityTraits = .none
        view.accessibilityHint = "새로운 기분을 등록하려면 두 번 탭 하세요."
        return view
    }()
    
    func setupAccessibilityLabel() {
        var elements = [Any]()
        [addMoodButton, collectionView].forEach { elements.append($0) }
        accessibilityElements = elements
    }
    
    override func configure() {
        [collectionView, addMoodButton].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        addMoodButton.snp.makeConstraints { make in
            make.size.equalTo(65)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 10
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: Section.today.header, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
