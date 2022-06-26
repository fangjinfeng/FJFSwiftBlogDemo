//
//  FJFLottieViewController.swift
//  FJFSwiftBlogDemo
//
//  Created by peakfang on 2022/5/16.
//

import UIKit
import Lottie
import SnapKit

private let kFJFProgressPositionAnimationKey = "kFJFProgressPositionAnimationKey"

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
    public func amountAnimation(_ startPostion: CGPoint) {
        let endPosition = self.redPacketOpenAnimation.center
        let animationPath = UIBezierPath.init()
        animationPath.move(to: startPostion)
        let controlX = startPostion.x + (endPosition.x - startPostion.x)/2.5
        let controlY = startPostion.y - (endPosition.y - startPostion.y) * 0.8
        let controlPostion = CGPoint(x: controlX, y: controlY)
        animationPath.addQuadCurve(to: endPosition, controlPoint: controlPostion)
        
       
        
        let rockAnimation =  CAKeyframeAnimation.init(keyPath: "transform.rotation")
        rockAnimation.values = [FJFLottieViewController.angleToRadian(30), FJFLottieViewController.angleToRadian(0), FJFLottieViewController.angleToRadian(-30),FJFLottieViewController.angleToRadian(0)]
        rockAnimation.duration = 1;
        rockAnimation.beginTime = 0.0

        
        let animation = CAKeyframeAnimation.init(keyPath: "position")
        animation.duration = 0.5
        animation.beginTime = 0.4
        animation.path = animationPath.cgPath
        
        let animationGroup = CAAnimationGroup.init()
        animationGroup.animations = [rockAnimation, animation]
        animationGroup.duration = 0.9
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = true
        self.amountLabel.layer.add(rockAnimation, forKey: "amountAnimationKey")
    }
    
    /// 获取 平移 动画
    public class func getPositionAnimation(_ duration: CGFloat,
                                           _ offsetX: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = duration
        animation.byValue = offsetX
        return animation
    }
    
    /// 获取 宽度  动画
    public class func getWidthAnimation(_ duration: CGFloat,
                                           _ bounds: CGRect) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = duration
        animation.byValue = NSValue.init(cgRect:bounds)
        return animation
    }
    
    private class func angleToRadian(_ angle: CGFloat) -> CGFloat {
        return ((angle) / 180.0 * Double.pi)
    }
    // MARK: - Private
    private func setupViewControls() {
        self.view.addSubview(self.amountLabel)
        self.view.addSubview(self.progressAnimation)
        self.view.addSubview(self.progressMaskView)
        self.view.addSubview(self.redPacketOpenAnimation)
        self.view.addSubview(self.redPacketUnopenAnimation)
        self.view.addSubview(self.animationStartButton)
        self.view.addSubview(self.progressSecondAnimation)
        self.title = "progressView"
        self.view.backgroundColor = .white
    }
    
    private func layoutViewControls() {
        
        self.amountLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview().offset(-100)
        }
        
        self.progressAnimation.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        self.progressMaskView.snp.makeConstraints { make in
            make.left.equalTo(self.progressAnimation)
            make.right.centerY.height.equalTo(self.progressAnimation)
        }
        
        self.progressSecondAnimation.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(60)
            make.height.equalTo(15)
        }
        
        self.redPacketUnopenAnimation.snp.makeConstraints { make in
            make.right.equalTo(self.progressAnimation)
            make.bottom.equalTo(self.progressAnimation).offset(-10)
            make.height.equalTo(50)
            make.width.equalTo(40)
        }
        
        self.redPacketOpenAnimation.snp.makeConstraints { make in
            make.edges.equalTo(self.redPacketUnopenAnimation)
        }
        
        self.animationStartButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.height.equalTo(60)
            make.width.equalTo(120)
        }
    }
    
    // MARK: - Response event
    /// 提交结果
    @objc
    func startAnimation() {
//        self.amountLabel.text = "90"
//        FJFAnimationHelper.showReplaceAnimation(self.amountLabel, self.view)
//        self.amountLabel.text = "放大就奋斗精神"
        self.amountAnimation(self.amountLabel.center)
        self.progressAnimation.play()
        self.progressSecondAnimation.play()
//        self.redPacketUnopenAnimation.play()
//        self.progressMaskView.isHidden = false
//        self.redPacketUnopenAnimation.isHidden = false
//
//        let offsetX = self.progressAnimation.frame.width
//        self.progressMaskView.snp.updateConstraints { make in
//            make.left.equalTo(self.progressAnimation).offset(offsetX)
//        }
        
       
        let offsetX = self.progressAnimation.frame.width
        var tmpRect = CGRect.init(x: offsetX, y: 0, width: 0, height: self.progressAnimation.height)
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = 10
        animation.fromValue = self.progressAnimation.bounds
        animation.toValue = NSValue.init(cgRect:tmpRect)
        
        
        let positionAnimation = FJFLottieViewController.getWidthAnimation(20, tmpRect)
//        positionAnimation.delegate = self
        self.progressMaskView.layer.add(animation, forKey: kFJFProgressPositionAnimationKey)
//        self.progressPositionAnimation = positionAnimation
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//            let tintFrame = self.progressMaskView.layer.presentation()?.frame ?? CGRect(x: 200, y: 0, width: 209, height: 10)
//            self.progressMaskView.layer.removeAllAnimations()
//            self.progressMaskView.frame = tintFrame
//            let secondOffsetX = self.progressAnimation.frame.width - tintFrame.origin.x
//            let positionAnimation = FJFLottieViewController.getPositionAnimation(3, secondOffsetX)
//            positionAnimation.delegate = self
//            self.progressMaskView.layer.add(positionAnimation, forKey: kFJFProgressPositionAnimationKey)
//        }
    }
    
    /// 恢复进度条 视图
    private func restoreProgressMaskViewPoistion() {
        self.progressMaskView.isHidden = true
        self.progressMaskView.snp.updateConstraints { make in
            make.left.equalTo(self.progressAnimation)
        }
    }
    
    /// 显示 红包开启动画
    private func showRedPacketOpenAnimation() {
        self.redPacketUnopenAnimation.isHidden = true
        self.redPacketOpenAnimation.isHidden = false
        self.redPacketOpenAnimation.play { [weak self] _ in
            guard let self = self else {
                return
            }
        }
    }
    
    // MARK: - Lazy
    
    lazy var redPacketOpenAnimation: AnimationView = {
        let animation = AnimationView(name: "xl_red_packet_after_receiving_animation")
        animation.loopMode = .playOnce
        animation.backgroundBehavior = .pauseAndRestore
        animation.isHidden = true
        return animation
    }()

    lazy var redPacketUnopenAnimation: AnimationView = {
        let animation = AnimationView(name: "xl_red_packet_before_receiving_animation")
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        return animation
    }()
    
    lazy var progressAnimation: AnimationView = {
        let animation = AnimationView(name: "xl_wait_timeout_progress_animation")
        animation.loopMode = .playOnce
        animation.backgroundBehavior = .pauseAndRestore
        return animation
    }()
    
    
    lazy var progressSecondAnimation: AnimationView = {
        let animation = AnimationView(name: "xl_wait_pay_progress_animation")
        animation.loopMode = .playOnce
        animation.backgroundBehavior = .pauseAndRestore
        return animation
    }()
    
    /// 遮罩view
    lazy var progressMaskView: UIView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "fjf_wait_timeout_progress_mask_icon")
        view.contentMode = .scaleToFill
        view.backgroundColor = .red
        return view
    }()
    
    /// 开始动画按键
    lazy var animationStartButton: UIButton = {
        let button = UIButton.init(frame: CGRect.zero)
        button.setTitle("开始动画", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
    
    /// 金额
    lazy var amountLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .red
        lbl.text = "90"
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
}
extension FJFLottieViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.progressMaskView.layer.animation(forKey: kFJFProgressPositionAnimationKey) == anim {
            print("-------------------------")
        }
    }
 }
