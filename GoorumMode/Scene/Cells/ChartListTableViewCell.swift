//
//  ChartListTableViewCell.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/11/11.
//

import UIKit

final class ChartListTableViewCell: BaseTableViewCell {
    
    let iconImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let progressView = RoundedProgressView()
    
    let label = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = Constants.Font.regular(size: 14)
        view.textColor = Constants.Color.Text.basicTitle
        return view
    }()
    
    func configureCell(item: String, moodData: MoodData) {
        iconImageView.image = UIImage(named: item)
//            cell.label.text = "\(Int(moodData.sortedPercent[indexPath.item]))% / \(moodData.moodCount[item] ?? 0)개"
        let count = moodData.moodCount[item] ?? 0
        label.text = "moodCount".localized(with: String(count))
        
        let maxCount = moodData.moodCount.values.max() ?? 0
        let progress = Float(Double(count) / Double(maxCount))
//        progressView.setProgress(progress, animated: true)
        progressView.progress = progress
        progressView.progressTintColor = UIColor(named: item + "_Background")
        
        selectionStyle = .none
    }
    
    func setChartCellAccessibility(_ name: String, moodData: MoodData, row: Int) {
        let emptyString = "pickChartView_noDataText".localized
        let moodAccessibilityLabel = MoodEmojis(rawValue: name)?.accessLabel ?? emptyString
        let count = String(moodData.moodCount[name] ?? 0)
        let percent = String(Int(moodData.sortedPercent[row]))
        
        let value = NSLocalizedString("setChartCellAccessibility_AccessibilityLabel", comment: "")
        accessibilityLabel = String(format: value, moodAccessibilityLabel, percent, count)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        progressView.progress = 0
    }
    
    override func configure() {
        super.configure()
        
        [progressView, iconImageView, label].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
        }
        
        label.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-40)
            make.leading.equalTo(progressView.snp.trailing).offset(8)
            make.centerY.equalTo(iconImageView)
        }
        
        progressView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(10)
            make.center.equalToSuperview()
        }
    }
}

// MARK: - RoundedProgressView
class RoundedProgressView: UIProgressView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func commonInit() {
        trackTintColor = Constants.Color.Background.progressTrack
        clipsToBounds = true
        accessibilityElementsHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.mask = CAShapeLayer.roundedRectMask(for: bounds, cornerRadius: 5)
    }
}

extension CAShapeLayer {
    static func roundedRectMask(for rect: CGRect, cornerRadius: CGFloat) -> CAShapeLayer {
        let mask = CAShapeLayer()
        if rect.width > 0 && rect.height > 0 {
            mask.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        }
        return mask
    }
}
