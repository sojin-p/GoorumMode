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
        view.text = "2023.10.10. 화요일"
        view.textAlignment = .center
        view.textColor = Constants.Color.Text.basicSubTitle
        view.font = Constants.Font.extraBold(size: 16)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let selectDateButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        view.tintColor = Constants.Color.Text.basicSubTitle
        return view
    }()
    
    lazy var collectionView = {
        let view =  UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = Constants.Color.Background.basic
        return view
    }()
    
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
        setupAccessibilityLabel()
        [dateLabel, selectDateButton, collectionView, addMoodButton].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(5)
            make.centerX.equalToSuperview().offset(-10)
            make.height.equalTo(20)
        }
        
        selectDateButton.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing)
            make.size.equalTo(35)
            make.centerY.equalTo(dateLabel)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        addMoodButton.snp.makeConstraints { make in
            make.size.equalTo(65)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(35)
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
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
