//
//  TableViewSectionDropDownSectionCell.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/20.
//

import UIKit

final class TableViewSectionDropDownSectionCell: UITableViewCell {
    static let identifier = "TableViewSectionDropDownSectionCell"
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
