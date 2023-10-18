//
//  MoodView.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/26.
//

import UIKit

final class MoodView: BaseView {
    
    let dateLabel = {
        let view = UILabel()
        view.text = Date().toString(of: .dateForTitle)
        view.textAlignment = .center
        view.textColor = Constants.Color.Text.basicSubTitle
        view.font = Constants.Font.extraBold(size: 16)
        view.sizeToFit()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var collectionView = {
        let view =  UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = Constants.Color.Background.basic
        view.isAccessibilityElement = false
        view.shouldGroupAccessibilityChildren = true
        return view
    }()
    
    let collectionViewPlaceholder = PlaceholderView()
    
    let addMoodButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        DispatchQueue.main.async {
            view.setImage(image, for: .normal)
            view.tintColor = Constants.Color.iconTint.basicWhite
            view.backgroundColor = Constants.Color.Background.basicIcon
            view.layer.cornerRadius = view.frame.width / 2
        }
        view.accessibilityLabel = "기록 추가"
        view.accessibilityHint = "새로운 기분을 기록하려면 두 번 탭 하세요."
        return view
    }()
    
    func setupAccessibilityLabel() {
        var elements = [Any]()
        [addMoodButton, collectionView].forEach { elements.append($0) }
        accessibilityElements = elements
    }
    
    override func configure() {
        setupAccessibilityLabel()
        [collectionView, collectionViewPlaceholder, addMoodButton].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        collectionViewPlaceholder.snp.makeConstraints { make in
            make.center.equalTo(collectionView)
            make.horizontalEdges.equalTo(collectionView)
        }
        
        addMoodButton.snp.makeConstraints { make in
            make.size.equalTo(65)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(35)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
