//
//  TopTabBarMainController.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/25.
//

import UIKit
import SnapKit

enum tabBarViewDirection: Int {
    case left = 0
    case right
}

final class TopTabBarMainController: UIViewController {
    
    // MARK: - View
    private let topTabBar: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var firstItem: UIButton = {
        let button = UIButton()
        configureTabButtonItem(btn: button, title: "first", tag: 0)
        
        return button
    }()
    
    private lazy var secondItem: UIButton = {
        let button = UIButton()
        configureTabButtonItem(btn: button, title: "second", tag: 1)
        
        return button
    }()
    
    private lazy var thirdItem: UIButton = {
        let button = UIButton()
        configureTabButtonItem(btn: button, title: "third", tag: 2)
        
        return button
    }()
    
    private let tabItemSelectedIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        
        return view
    }()
    
    private let contentView = UIView()
    
    private let firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }()
    
    private let secondView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        
        return view
    }()
    
    private let thirdView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        
        return view
    }()

    // MARK: - Properties
    private let tabBarItemWidth = screenFrame.width / 3
    private var direction: tabBarViewDirection = .left
    private var currentTabItemTag = 0
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(topTabBar)
        view.addSubview(contentView)
        [firstItem, secondItem, thirdItem, tabItemSelectedIndicator].forEach { topTabBar.addSubview($0) }
        [firstView, secondView, thirdView].forEach { contentView.addSubview($0) }
        configureConstraints()
        firstItem.isSelected = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureGesture()
    }
    
    // MARK: - Method
    private func configureConstraints() {
        topTabBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        firstItem.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(tabBarItemWidth)
            $0.height.equalTo(50)
        }
        
        secondItem.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(firstItem.snp.trailing)
            $0.width.equalTo(tabBarItemWidth)
            $0.height.equalTo(50)
        }
        
        thirdItem.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(secondItem.snp.trailing)
            $0.width.equalTo(tabBarItemWidth)
            $0.height.equalTo(50)
        }
        
        tabItemSelectedIndicator.snp.makeConstraints {
            $0.top.equalTo(topTabBar.snp.bottom)
            $0.width.equalTo(tabBarItemWidth)
            $0.centerX.equalTo(firstItem)
            $0.height.equalTo(5)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(tabItemSelectedIndicator.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        firstView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        secondView.snp.makeConstraints {
            $0.top.width.height.equalToSuperview()
            $0.leading.equalTo(firstView.snp.trailing)
        }
        
        thirdView.snp.makeConstraints {
            $0.top.width.height.equalToSuperview()
            $0.leading.equalTo(secondView.snp.trailing)
        }
    }
    
    private func configureTabButtonItem(btn: UIButton, title: String, tag: Int) {
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.tag = tag
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.setTitleColor(UIColor.label, for: .selected)
        btn.addTarget(self, action: #selector(selectedTabBarItem(_:)), for: .touchUpInside)
    }
    
    private func configureGesture() {
        [firstView, secondView, thirdView].forEach {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(contentViewPanGesture(_:)))
            $0.addGestureRecognizer(panGesture)
        }
    }
    
    private func setSwipeAnimationDirection(view: UIView) {
        let swipeViewAnimation = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
        var margine = CGFloat.zero
        direction = view.frame.minX < 0 ? .right : .left
        switch self.direction {
        case .left:
            margine = screenFrame.width - view.frame.minX
        case .right:
            margine = -view.frame.maxX
        }

        swipeViewAnimation.addAnimations {
            [self.firstView, self.secondView, self.thirdView].forEach {
                $0.frame.origin.x += margine
            }
            self.tabItemSelectedIndicator.frame.origin.x = self.direction == .left ?
            self.tabItemSelectedIndicator.frame.origin.x - self.tabItemSelectedIndicator.frame.width / view.frame.width * abs(margine) :
            self.tabItemSelectedIndicator.frame.origin.x + self.tabItemSelectedIndicator.frame.width / view.frame.width * abs(margine)
        }
        
        swipeViewAnimation.addCompletion { _ in
            self.currentTabItemTag = self.direction == .left ?
            self.currentTabItemTag - 1 : self.currentTabItemTag + 1
            
            [self.firstItem, self.secondItem, self.thirdItem].forEach {
                if $0.tag == self.currentTabItemTag {
                    $0.isSelected = true
                } else {
                    $0.isSelected = false
                }
            }
        }
        
        swipeViewAnimation.startAnimation()
    }
    
    // MARK: - targetMethod
    @objc private func selectedTabBarItem(_ sender: UIButton) {
        let moveDirection: CGFloat = CGFloat(currentTabItemTag - sender.tag)
        
        currentTabItemTag = sender.tag
        if moveDirection > 0 {
            direction = .left
        } else {
            direction = .right
        }
        
        [firstItem, secondItem, thirdItem].forEach { $0.isSelected = false }
        sender.isSelected = true
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            [self.firstView, self.secondView, self.thirdView].forEach { $0.frame.origin.x += self.contentView.frame.width * moveDirection }
            self.tabItemSelectedIndicator.frame.origin.x -= self.tabBarItemWidth * moveDirection
        }
    }
    
    @objc private func contentViewPanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let delta = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            direction = delta.x < 0 ? .right : .left
            tabItemSelectedIndicator.frame.origin.x = direction == .left ?
            tabItemSelectedIndicator.frame.origin.x - tabItemSelectedIndicator.frame.width / view.frame.width * abs(delta.x) :
            tabItemSelectedIndicator.frame.origin.x + tabItemSelectedIndicator.frame.width / view.frame.width * abs(delta.x)
            
            [firstView, secondView, thirdView].forEach {
                switch direction {
                case .left:
                    $0.frame.origin.x += abs(delta.x)
                case .right:
                    $0.frame.origin.x -= abs(delta.x)
                }
                gesture.setTranslation(.zero, in: view)
            }
        case .ended:
            setSwipeAnimationDirection(view: view)
        default:
            break
        }
    }
}
