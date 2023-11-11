//
//  ChartListTableViewCell.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/11/11.
//

import UIKit

final class ChartListTableViewCell: BaseTableViewCell {
    
    let collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        view.register(ChartListCollectionViewCell.self, forCellWithReuseIdentifier: ChartListCollectionViewCell.reuseIdentifier)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    override func configure() {
        [collectionView].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private static func layout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        
        return layout
    }
}
