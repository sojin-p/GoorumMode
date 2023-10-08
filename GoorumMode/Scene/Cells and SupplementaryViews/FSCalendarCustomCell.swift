//
//  FSCalendarCustomCell.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/09.
//

import UIKit
import FSCalendar

final class FSCalendarCustomCell: FSCalendarCell {
    
    static let identifier = "FSCalendarCustomCell"
    
    let moodImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        DispatchQueue.main.async {
            view.layer.cornerRadius = view.frame.width / 2
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(moodImageView)
        
        moodImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(1.11)
        }
    }
    
    @available(*, unavailable)
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
}
