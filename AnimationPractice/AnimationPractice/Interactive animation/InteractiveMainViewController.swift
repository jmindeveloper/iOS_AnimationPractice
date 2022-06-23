//
//  InteractiveMainViewController.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/23.
//

import UIKit
import SnapKit

enum InteractiveAnimationPosition {
    case start
    case end
    
    mutating func toggle() {
        self = self == .end ? .start : .end
    }
}

final class InteractiveMainViewController: UIViewController {

    // MARK: - View
    private let redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }()
    
    private let blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        
        return view
    }()
    
    let nonInteractiveLabel: UILabel = {
        let label = UILabel()
        label.text = "nonInteractiveLabel"
        
        return label
    }()
    
    let interactiveLabel: UILabel = {
        let label = UILabel()
        label.text = "interactiveLabel"
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "--> swipe <--"
        
        return label
    }()
    
    // MARK: - Properties
    private var interactiveAnimation = UIViewPropertyAnimator(duration: 1, curve: .linear)
    private var interactiveAnimationPosition = InteractiveAnimationPosition.start
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        [redView, blueView, nonInteractiveLabel, interactiveLabel, descriptionLabel].forEach {
            view.addSubview($0)
        }
        configureConstraints()
        configureGesture()
    }
    
    // MARK: - Method
    private func configureConstraints() {
        nonInteractiveLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(safeAreaInset.top + 100)
            $0.leading.equalToSuperview().offset(20)
        }
        
        redView.snp.makeConstraints {
            $0.top.equalTo(nonInteractiveLabel.snp.bottom).offset(20)
            $0.leading.equalTo(nonInteractiveLabel.snp.leading)
            $0.width.height.equalTo(40)
        }
        
        interactiveLabel.snp.makeConstraints {
            $0.top.equalTo(redView.snp.bottom).offset(20)
            $0.leading.equalTo(nonInteractiveLabel.snp.leading)
        }
        
        blueView.snp.makeConstraints {
            $0.top.equalTo(interactiveLabel.snp.bottom).offset(20)
            $0.leading.equalTo(nonInteractiveLabel.snp.leading)
            $0.width.height.equalTo(40)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(blueView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nonInteractiveTapGesture(_:)))
        redView.addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(interactivePanGesture(_:)))
        blueView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - TargetMethod
    @objc private func nonInteractiveTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        UIView.animate(withDuration: 1) {
            view.transform = CGAffineTransform(translationX: self.view.frame.maxX - 80, y: 0)
        }
    }
    
    @objc private func interactivePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            interactiveAnimation.addAnimations {
                switch self.interactiveAnimationPosition {
                case .start:
                    self.blueView.transform = CGAffineTransform(translationX: self.view.frame.maxX - 80, y: 0)
                case .end:
                    self.blueView.transform = .identity
                }
            }
            
            interactiveAnimation.addCompletion {
                switch $0 {
                case .end:
                    self.interactiveAnimationPosition.toggle()
                default:
                    break
                }
            }
            // active상태이나 애니메이션은 멈춰있는 상태
            interactiveAnimation.pauseAnimation()
        case .changed:
            let delta = gesture.translation(in: blueView)
            // view의 움직임이 실제 드래깅한 위치랑 같게 해줄려면(손가락 위치)
            // delta.x / view가 이동하는 범위 를 해주면 된다
            // ex) delta.x / (view.frame.width - 80)
            let percent = abs(delta.x / (view.frame.width - 200))
            // 애니메이션의 진행율 (애니메이션 실행x)
            interactiveAnimation.fractionComplete = percent
        case .ended:
            if interactiveAnimation.fractionComplete < 0.5 {
                // 진행율이 절반이 안되면 애니메이션 반대로 실행
                interactiveAnimation.isReversed = true
            }
            // 일시정지돼있는 애니메이션의 지속시간을 바꿀거임ㅇㅇ (애니메이션 실행)
            interactiveAnimation.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve: .linear), durationFactor: 0.2)
            interactiveAnimation.pauseAnimation()
        case .cancelled:
            interactiveAnimation.pauseAnimation()
            interactiveAnimation.stopAnimation(false)
            interactiveAnimation.finishAnimation(at: .start)
        default:
            break
        }
    }
}
