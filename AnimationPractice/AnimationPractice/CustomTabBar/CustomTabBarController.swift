//
//  CustomTabBarController.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/24.
//

import UIKit
import SnapKit

final class CustomTabBarController: UITabBarController {
    
    // MARK: - View
    private let customTabBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var tabItem1: UIButton = {
        let button = UIButton()
        configureTabButtonItem(btn: button, title: "first", tag: 0)
        
        return button
    }()
    
    private lazy var tabItem2: UIButton = {
        let button = UIButton()
        configureTabButtonItem(btn: button, title: "second", tag: 1)
        
        return button
    }()
    
    private lazy var tabItem3: UIButton = {
        let button = UIButton()
        configureTabButtonItem(btn: button, title: "third", tag: 2)
        
        return button
    }()
    
    private let tabItemSelectedIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    // MARK: - Properties
    private let tabBarItemWidth = screenFrame.width / 3
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    // MARK: - Method
    private func configureTabBar() {
        let vc1 = CustomTabViewController1()
        let vc2 = CustomTabViewController2()
        let vc3 = CustomTabViewController3()
        
        setViewControllers([vc1, vc2, vc3], animated: true)
        tabBar.isHidden = true
        
        view.addSubview(customTabBar)
        [tabItem1, tabItem2, tabItem3, tabItemSelectedIndicator].forEach { customTabBar.addSubview($0) }
        tabItem1.isSelected = true
        configureConstraints()
    }
    
    private func configureTabButtonItem(btn: UIButton, title: String, tag: Int) {
        btn.setTitle(title, for: .normal)
        btn.tag = tag
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.setTitleColor(UIColor.label, for: .selected)
        btn.addTarget(self, action: #selector(selectedTabBarItem(_:)), for: .touchUpInside)
    }
    
    private func configureConstraints() {
        customTabBar.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(50 + safeAreaInset.bottom)
        }
        
        tabItemSelectedIndicator.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.width.height.equalTo(10)
            $0.centerX.equalTo(tabItem1)
        }
        
        tabItem1.snp.makeConstraints {
            $0.width.equalTo(tabBarItemWidth)
            $0.height.equalTo(20)
            $0.leading.equalToSuperview()
            $0.top.equalTo(tabItemSelectedIndicator.snp.bottom).offset(5)
        }
        
        tabItem2.snp.makeConstraints {
            $0.width.equalTo(tabBarItemWidth)
            $0.height.equalTo(20)
            $0.top.equalTo(tabItemSelectedIndicator.snp.bottom).offset(5)
            $0.leading.equalTo(tabItem1.snp.trailing)
        }
        
        tabItem3.snp.makeConstraints {
            $0.width.equalTo(tabBarItemWidth)
            $0.height.equalTo(20)
            $0.top.equalTo(tabItemSelectedIndicator.snp.bottom).offset(5)
            $0.leading.equalTo(tabItem2.snp.trailing)
        }
    }
    
    // MARK: - targetMethod
    @objc private func selectedTabBarItem(_ sender: UIButton) {
        [tabItem1, tabItem2, tabItem3].forEach { $0.isSelected = false }
        
        selectedIndex = sender.tag
        sender.isSelected = true
        
        tabItemSelectedIndicator.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.width.height.equalTo(10)
            $0.centerX.equalTo(sender)
        }
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
}
