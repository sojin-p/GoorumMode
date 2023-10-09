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
        view.font = Constants.Font.extraBold(size: 16)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let button = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        view.tintColor = Constants.Color.Text.basicSubTitle
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
        addSubview(button)
        
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview().offset(-10)
        }
        
        button.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing)
            make.size.equalTo(35)
            make.centerY.equalTo(label)
        }
    }
    
}
