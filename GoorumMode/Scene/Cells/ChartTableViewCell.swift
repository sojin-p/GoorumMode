//
//  ChartTableViewCell.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/10/14.
//

import UIKit
import DGCharts

final class ChartTableViewCell: BaseTableViewCell {
    
    let pieChartView = {
        let view = PieChartView()
        view.noDataText = "작성된 기분이 없습니다."
        view.noDataFont = Constants.Font.extraBold(size: 16)
        view.noDataTextColor = Constants.Color.Text.basicPlaceholder!
        view.drawHoleEnabled = false
        view.legend.enabled = false
        view.usePercentValuesEnabled = true
        return view
    }()
    
    override func configure() {
        contentView.backgroundColor = Constants.Color.Background.white
        contentView.addSubview(pieChartView)
    }
    
    override func setConstraints() {
        pieChartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
