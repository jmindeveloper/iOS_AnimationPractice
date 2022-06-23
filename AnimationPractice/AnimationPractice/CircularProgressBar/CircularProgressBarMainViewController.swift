//
//  CircularProgressBarMainViewController.swift
//  AnimationPractice
//
//  Created by J_Min on 2022/06/22.
//

import UIKit

final class CircularProgressBarMainViewController: UIViewController {
    
    var circularProgressBarView: CircularProgressBarView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpCircularProgressBarView()
    }
    
    func setUpCircularProgressBarView() {
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        circularProgressBarView?.center = view.center
        circularProgressBarView?.progressAnimation(duration: 2)
        view.addSubview(circularProgressBarView!)
    }
    
}
