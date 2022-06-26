//
//  FJFAnimationHelper.swift
//  FJFSwiftBlogDemo
//
//  Created by peakfang on 2022/5/17.
//

import Foundation
import UIKit

class FJFAnimationHelper {
    public class func toImage(_ view: UIView) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        view.layer.render(in: context)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage
    }
    
    /// 显示顶替动画效果
    public class func showReplaceAnimation(_ superView: UIView,
                                           _ originalView: UIView,
                                           _ originalImage: UIImage?,
                                           _ offsetY: CGFloat = 10,
                                           _ completionBlock: @escaping () -> ()) {
        superView.setNeedsLayout()
        superView.layoutIfNeeded()
        
        // 生成原来视图的临时占位图
        let originalImageView = UIImageView.init()
        if let tmpImage = originalImage {
            originalImageView.image = tmpImage
        } else {
            originalImageView.image = FJFAnimationHelper.toImage(originalView)
        }
        superView.addSubview(originalImageView)
        originalImageView.frame = originalView.frame
        originalImageView.alpha = 1
        
        // 修改原来图标的显示位置
        let originalViewY = originalView.y
        originalView.alpha = 0
        originalView.y = originalViewY + offsetY

        UIView.animate(withDuration: 0.16, delay: 0.0, options: .curveEaseOut) {
            originalImageView.y = originalImageView.frame.origin.y - offsetY
            originalImageView.alpha = 0
        } completion: { finish in
            if finish {
                originalImageView.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.42, delay: 0.0, options: .curveEaseOut) {
            originalView.alpha = 1
            originalView.y = originalViewY
        } completion: { finish in
            if finish {
                completionBlock()
            }
        }
    }
    
    /// 获取 摇晃 动画
    public class func getShakeAnimation(_ duration: CGFloat = 0.5) -> CAKeyframeAnimation {
        let rockAnimation = CAKeyframeAnimation.init(keyPath: "transform.rotation")
        rockAnimation.values = [FJFAnimationHelper.angleToRadian(20), FJFAnimationHelper.angleToRadian(0), FJFAnimationHelper.angleToRadian(-20), FJFAnimationHelper.angleToRadian(0)]
        rockAnimation.duration = duration
        rockAnimation.fillMode = .forwards
        return rockAnimation
    }
    
    /// 获取 抛物线 动画
    public class func getParabolaAnimation(_ duration: CGFloat = 0.5,
                                           _ startPostion: CGPoint,
                                           _ endPosition: CGPoint) -> CAKeyframeAnimation {
        let animationPath = UIBezierPath.init()
        animationPath.move(to: startPostion)
        let controlX = startPostion.x + (endPosition.x - startPostion.x) / 2.5
        let controlY = startPostion.y - (endPosition.y - startPostion.y) * 0.8
        let controlPostion = CGPoint(x: controlX, y: controlY)
        animationPath.addQuadCurve(to: endPosition, controlPoint: controlPostion)
        let animation = CAKeyframeAnimation.init(keyPath: "position")
        animation.duration = duration
        animation.path = animationPath.cgPath
        animation.isRemovedOnCompletion = false
        return animation
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
    
    private class func angleToRadian(_ angle: CGFloat) -> CGFloat {
        return ((angle) / 180.0 * Double.pi)
    }
}


