//
//  PlaceholderView.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/16.
//

import UIKit

final class PlaceholderView: BaseView {
    
    lazy var imageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .launchScreen)
        return view
    }()
    
    let placehoderLabel = {
        let view = UILabel()
        view.text = "moodCollectionView_PlaceholderLabel".localized
        view.font = Constants.Font.bold(size: 15)
        view.textColor = Constants.Color.Text.basicSubTitle
        view.textAlignment = .center
        return view
    }()
    
    override func configure() {
        [imageView, placehoderLabel].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview().offset(-25)
        }
        
        placehoderLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(25)
        }
        
    }
}
 
