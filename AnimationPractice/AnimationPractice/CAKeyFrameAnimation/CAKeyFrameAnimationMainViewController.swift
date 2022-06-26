//
//  CAKeyFrameAnimationMainViewController.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/26.
//

import UIKit
import SnapKit

final class CAKeyFrameAnimationMainViewController: UIViewController {
    
    // MARK: - View
    private let someView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }()
    
    private let rotationButton: UIButton = {
        let button = UIButton()
        button.setTitle("rotation", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()
    
    private let positionButton: UIButton = {
        let button = UIButton()
        button.setTitle("position", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()
    
    private let shakeButton: UIButton = {
        let button = UIButton()
        button.setTitle("shake", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()
    
    private let alphaButton: UIButton = {
        let button = UIButton()
        button.setTitle("opacity", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()
    
    private let allButton: UIButton = {
        let button = UIButton()
        button.setTitle("all", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        [someView, rotationButton, positionButton, shakeButton, alphaButton, allButton].forEach {
            view.addSubview($0)
        }
        configureConstraints()
        configureButtonTarget()
    }
    
    // MARK: - Method
    private func configureConstraints() {
        someView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(70)
        }
        
        rotationButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(someView.snp.bottom).offset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }
        
        positionButton.snp.makeConstraints {
            $0.top.equalTo(rotationButton.snp.bottom).offset(5)
            $0.centerX.size.equalTo(rotationButton)
        }
        
        shakeButton.snp.makeConstraints {
            $0.centerX.size.equalTo(rotationButton)
            $0.top.equalTo(positionButton.snp.bottom).offset(5)
        }
        
        alphaButton.snp.makeConstraints {
            $0.centerX.size.equalTo(rotationButton)
            $0.top.equalTo(shakeButton.snp.bottom).offset(5)
        }
        
        allButton.snp.makeConstraints {
            $0.centerX.size.equalTo(rotationButton)
            $0.top.equalTo(alphaButton.snp.bottom).offset(5)
        }
    }
    
    private func configureButtonTarget() {
        rotationButton.addTarget(self, action: #selector(rotationAnimationStart), for: .touchUpInside)
        positionButton.addTarget(self, action: #selector(positionAnimationStart), for: .touchUpInside)
        shakeButton.addTarget(self, action: #selector(shakeAnimationStart), for: .touchUpInside)
        alphaButton.addTarget(self, action: #selector(alphaAnimationStart), for: .touchUpInside)
        allButton.addTarget(self, action: #selector(allAnimationStart), for: .touchUpInside)
    }
    
    private func rotationAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.duration = 1
        animation.repeatCount = 1
        animation.values = [0, .pi / 2.0, .pi * 1.0, (.pi * 3.0) / 2.0, .pi * 2.0, 0]
        animation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        someView.layer.add(animation, forKey: "rotation")
    }
    
    private func positionAnimation() {
        let xAnimation = CAKeyframeAnimation(keyPath: "position.x")
        xAnimation.duration = 1
        xAnimation.repeatCount = 1
        xAnimation.values = [0, 100, 0]
        xAnimation.keyTimes = [0, 0.5, 1]
        xAnimation.isAdditive = true // 현재위치기 기준인지
        
        let yAnimation = CAKeyframeAnimation(keyPath: "position.y")
        yAnimation.duration = 1
        yAnimation.repeatCount = 1
        yAnimation.values = [0, 100, 0]
        yAnimation.keyTimes = [0, 0.5, 1]
        yAnimation.isAdditive = true
        
        someView.layer.add(xAnimation, forKey: "positino.x")
        someView.layer.add(yAnimation, forKey: "position.y")
    }
    
    private func shakeAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.duration = 1
        animation.repeatCount = 1
        animation.values = [0, -10, 10, -10, 5, -5, 5, 0]
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.isAdditive = true
        someView.layer.add(animation, forKey: "shake")
    }
    
    private func alphaAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.duration = 1
        animation.repeatCount = 1
        animation.values = [0, 1]
        animation.keyTimes = [0, 1]
        someView.layer.add(animation, forKey: "alpha")
    }
    
    // MARK: - TargetMethod
    @objc private func rotationAnimationStart() {
        rotationAnimation()
    }
    
    @objc private func positionAnimationStart() {
        positionAnimation()
    }
    
    @objc private func shakeAnimationStart() {
        shakeAnimation()
    }
    
    @objc private func alphaAnimationStart() {
        alphaAnimation()
    }
    
    @objc private func allAnimationStart() {
        rotationAnimation()
        positionAnimation()
        shakeAnimation()
        alphaAnimation()
    }
}

/*
 레이어의 키프레임 애니메이션은 UIView의 키프레임 애니메이션과 약간 다릅니다. 뷰 키프레임 애니메이션은 독립적인 간단한 애니메이션을 함께 결합하는 간단한 방법입니다; 그들은 다른 뷰와 속성을 애니메이션할 수 있으며, 애니메이션은 겹치거나 그 사이에 틈이 있을 수 있습니다.

 대조적으로, CAKeyframeAnimation을 사용하면 주어진 레이어에서 단일 속성을 애니메이션화할 수 있습니다. 애니메이션의 다른 요점을 정의할 수 있지만, 애니메이션에 틈이나 겹치는 것은 없습니다. 처음에는 제한적으로 들리지만, CAKeyframeAnimation으로 매우 매력적인 효과를 만들 수 있습니다.

 이 장에서는 실제 충돌을 시뮬레이션하는 기본 애니메이션부터 고급 애니메이션에 이르기까지 여러 레이어 키프레임 애니메이션을 만들 것입니다. 17장, "스트로크 및 경로 애니메이션"에서는 레이어 애니메이션을 더욱 발전시키고 주어진 경로를 따라 레이어를 애니메이션하는 방법을 배우게 됩니다.

 지금은 달리기 전에 걷고 첫 번째 레이어 키프레임 애니메이션을 위한 펑키한 흔들리는 효과를 만들 것입니다.
 */
