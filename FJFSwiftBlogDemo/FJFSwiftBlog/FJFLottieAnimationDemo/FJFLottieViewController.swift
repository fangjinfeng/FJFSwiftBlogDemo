//
//  FJFLottieViewController.swift
//  FJFSwiftBlogDemo
//
//  Created by peakfang on 2022/5/16.
//

import UIKit
import Lottie
import SnapKit

class FJFLottieViewController: UIViewController {

    /// 等待时长 进度条 动画
    private var progressPositionAnimation: CABasicAnimation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewControls()
        self.layoutViewControls()
        
    }
    
    // MARK: - Public
    // MARK: - Private
    private func setupViewControls() {
        self.view.addSubview(firstAnimationView)
        self.view.addSubview(secondAnimationView)
        self.title = "Lottie Animation"
        self.view.backgroundColor = .white
    }
    
    private func layoutViewControls() {
        firstAnimationView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-80)
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
            make.height.equalTo(100)
        }
        self.firstAnimationView.play()
       
        secondAnimationView.snp.makeConstraints { (make) in
            make.top.equalTo(self.firstAnimationView.snp_bottomMargin).offset(10)
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
            make.height.equalTo(100)
        }
        self.secondAnimationView.play()
    }

    // MARK: - Lazy
    lazy var firstAnimationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "dest_animation")
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        return animation
    }()
    
    
    lazy var secondAnimationView: LottieAnimationView = {
        let config = LottieConfiguration(renderingEngine: .coreAnimation, decodingStrategy: .codable)
        let animation = LottieAnimationView(name: "dest_animation", configuration: config)
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        return animation
    }()
}

