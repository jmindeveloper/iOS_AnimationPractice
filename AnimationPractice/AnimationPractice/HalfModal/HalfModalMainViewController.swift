//
//  HalfModalMainViewController.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/19.
//

import UIKit

final class HalfModalMainViewController: UIViewController {
    
    // MARK: - View
    private let presentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open ModalView", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        view.addSubview(presentButton)
        presentButton.addTarget(self, action: #selector(presentModalController), for: .touchUpInside)
        presentButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-70)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func presentModalController() {
        let vc = HalfModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false)
    }
}
