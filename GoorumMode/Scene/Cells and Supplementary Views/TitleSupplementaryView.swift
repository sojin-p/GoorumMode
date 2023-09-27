//
//  TitleSupplementaryView.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/26.
//

import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
    
    let label = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = Constants.Color.Text.basicSubTitle
        view.font = .systemFont(ofSize: 20, weight: .bold)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(30)
        }
    }
    
}
