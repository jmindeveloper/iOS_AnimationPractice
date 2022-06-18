//
//  BaseTableViewCell.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/18.
//

import UIKit
import SnapKit

final class BaseTableViewCell: UITableViewCell {
    static let identifier = "BaseTableViewCell"
    
    var label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
