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
        view.image = UIImage(named: "LaunchScreen")
        return view
    }()
    
    let placehoderLabel = {
        let view = UILabel()
        view.text = "작성된 기록이 없습니다."
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
            make.top.centerX.equalToSuperview()
        }
        
        placehoderLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
    }
}
 
