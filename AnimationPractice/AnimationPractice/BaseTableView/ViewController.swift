//
//  ViewController.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/18.
//

import UIKit

struct TableViewData {
    let title: String
    let vc: UIViewController
}

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewControllers: [TableViewData] = [
        TableViewData(title: "탭한대로 뷰 이동", vc: TapAndMoveViewController()),
        TableViewData(title: "half modal", vc: HalfModalMainViewController()),
        TableViewData(title: "테이블뷰 드롭다운", vc: TableViewSectionDropDownMainViewController()),
        TableViewData(title: "원형 프로그레스바", vc: CircularProgressBarMainViewController()),
        TableViewData(title: "Interactive Animation", vc: InteractiveMainViewController())
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: BaseTableViewCell.identifier)
        
        tableView.rowHeight = 40
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCell.identifier, for: indexPath) as? BaseTableViewCell else { return UITableViewCell() }
        
        cell.label.text = viewControllers[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = viewControllers[indexPath.row].vc
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

