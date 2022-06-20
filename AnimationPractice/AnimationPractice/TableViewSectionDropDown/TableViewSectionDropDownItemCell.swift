//
//  TableViewSectionDropDownItemCell.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/20.
//

import UIKit

final class TableViewSectionDropDownItemCell: UITableViewCell {
    static let identifier = "TableViewSectionDropDownItemCell"
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
