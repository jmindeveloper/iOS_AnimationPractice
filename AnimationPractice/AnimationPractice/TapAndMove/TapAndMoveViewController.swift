//
//  TapAndMoveViewController.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/18.
//

import UIKit

class TapAndMoveViewController: UIViewController {
    
    private let yellowView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(yellowView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: view) {
            print("x: \(location.x), y: \(location.y)")
            moveView(location: location)
        }
    }
    
    private func moveView(location: CGPoint) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.yellowView.center = location
        } completion: { _ in
            print("이동완료")
        }

    }
}
