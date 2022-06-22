//
//  HalfModalViewController.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/19.
//

import UIKit

final class HalfModalViewController: UIViewController {
    
    // MARK: - View
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Using this presentation style, the current view controller's content is displayed over the view controller whose definesPresentationContext property is true. UIKit may walk up the view controller hierarchy to find a view controller that wants to define the presentation context. The views beneath the presented content are not removed from the view hierarchy when the presentation finishes. So if the presented view controller does not fill the screen with opaque content, the underlying content shows through. When presenting a view controller in a popover, this presentation style is supported only if the transition style is UIModalTransitionStyle.coverVertical. Attempting to use a different transition style triggers an exception. However, you may use other transition styles (except the partial curl transition) if the parent view controller is not in a popover.Using this presentation style, the current view controller's content is displayed over the view controller whose definesPresentationContext property is true. UIKit may walk up the view controller hierarchy to find a view controller that wants to define the presentation context. The views beneath the presented content are not removed from the view hierarchy when the presentation finishes. So if the presented view controller does not fill the screen with opaque content, the underlying content shows through. When presenting a view controller in a popover, this presentation style is supported only if the transition style is UIModalTransitionStyle.coverVertical. Attempting to use a different transition style triggers an exception. However, you may use other transition styles (except the partial curl transition) if the parent view controller is not in a popover."
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        return view
    }()
    
    // MARK: - Properties
    let defaultHeight: CGFloat = 350
    let dismissHeight: CGFloat = 200
    let maximumHeight: CGFloat = screenFrame.height - safeAreaInset.top - 30
    lazy var currentHeight: CGFloat = defaultHeight
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
        configurePanGesture()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDimmedView))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentContainerAnimation()
    }
    
    // MARK: - Method
    private func addSubviews() {
        view.backgroundColor = .clear
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubview(mainLabel)
    }
    
    private func configureConstraints() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        mainLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configurePanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - TargetMethod
    @objc private func tapDimmedView() {
        dismissAnimation()
    }
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let panOrigin = sender.translation(in: view)
        print("PanGesture y offset: \(panOrigin.y)")
        
        let isDraggingDown = panOrigin.y > 0
        print("Dragging direction: \(isDraggingDown ? "down" : "up")")
        
        let newHeight = currentHeight - panOrigin.y
        print("newHeightL \(newHeight)")
        
        switch sender.state {
        case .changed:
            if newHeight < maximumHeight {
                containerView.snp.updateConstraints {
                    $0.height.equalTo(newHeight)
                }
            }
        case .ended:
            if newHeight < defaultHeight, newHeight > dismissHeight {
                heightConstraintsChangeAnimation(newHeight: defaultHeight)
                currentHeight = defaultHeight
            } else if newHeight < defaultHeight, newHeight < dismissHeight {
                dismissAnimation()
            } else if newHeight > defaultHeight, isDraggingDown {
                heightConstraintsChangeAnimation(newHeight: defaultHeight)
                currentHeight = defaultHeight
            } else if newHeight > defaultHeight, !isDraggingDown {
                heightConstraintsChangeAnimation(newHeight: maximumHeight)
                currentHeight = maximumHeight
            }
        default: break
        }
    }
    
    // MARK: - AnimationMehotd
    private func presentContainerAnimation() {
        containerView.snp.updateConstraints {
            $0.height.equalTo(defaultHeight)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.dimmedView.alpha = 0.6
        }
    }
    
    private func heightConstraintsChangeAnimation(newHeight height: CGFloat) {
        containerView.snp.updateConstraints() {
            $0.height.equalTo(height)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func dismissAnimation() {
        containerView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.dimmedView.alpha = 0
            self?.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
        }

    }
}
