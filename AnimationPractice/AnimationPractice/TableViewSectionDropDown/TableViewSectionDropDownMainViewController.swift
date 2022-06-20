//
//  TableViewSectionDropDownMainViewController.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/20.
//

import UIKit
import SnapKit

final class TableViewSectionDropDownMainViewController: UIViewController {
    
    // MARK: - View
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewSectionDropDownSectionCell.self, forCellReuseIdentifier: TableViewSectionDropDownSectionCell.identifier)
        tableView.register(TableViewSectionDropDownItemCell.self, forCellReuseIdentifier: TableViewSectionDropDownItemCell.identifier)
        
        return tableView
    }()
    
    // MARK: - Properties
    private var sectionIsOpen = false
    private let tableViewItems = ["Section", "a", "b", "c", "d"]
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
    }
    
}

extension TableViewSectionDropDownMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionIsOpen ? tableViewItems.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionCell = tableView.dequeueReusableCell(withIdentifier: TableViewSectionDropDownSectionCell.identifier, for: indexPath) as? TableViewSectionDropDownSectionCell,
              let itemCell = tableView.dequeueReusableCell(withIdentifier: TableViewSectionDropDownItemCell.identifier, for: indexPath) as? TableViewSectionDropDownItemCell else { return UITableViewCell() }
        
        sectionCell.label.text = tableViewItems[indexPath.row]
        itemCell.label.text = tableViewItems[indexPath.row]
        
        switch sectionIsOpen {
        case false:
            return sectionCell
        case true:
            if indexPath.row == 0 {
                return sectionCell
            } else {
                return itemCell
            }
        }
    }
}

extension TableViewSectionDropDownMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            sectionIsOpen.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
        default:
            print(tableViewItems[indexPath.row])
        }
    }
}
