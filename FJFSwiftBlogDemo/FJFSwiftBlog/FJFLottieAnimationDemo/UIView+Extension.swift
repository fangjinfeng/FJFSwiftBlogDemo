//
//  UIView+Extension.swift
//  FJFSwiftBlogDemo
//
//  Created by peakfang on 2022/5/17.
//

import UIKit
import Foundation
import CoreFoundation

public extension UIView {
    // MARK: 3.1、x 的位置
    /// x 的位置
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.x = newValue
            self.frame = tempFrame
        }
    }
    // MARK: 3.2、y 的位置
    /// y 的位置
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.y = newValue
            self.frame = tempFrame
        }
    }
    
    // MARK: 3.3、height: 视图的高度
    /// height: 视图的高度
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.size.height = newValue
            self.frame = tempFrame
        }
    }
    
    // MARK: 3.4、width: 视图的宽度
    /// width: 视图的宽度
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.size.width = newValue
            self.frame = tempFrame
        }
    }
    
    // MARK: 3.5、size: 视图的zize
    /// size: 视图的zize
    var size: CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.size = newValue
            self.frame = tempFrame
        }
    }
    
    // MARK: 3.6、centerX: 视图的X中间位置
    /// centerX: 视图的X中间位置
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = self.center
            tempCenter.x = newValue
            self.center = tempCenter
        }
    }
    
    // MARK: 3.7、centerY: 视图的Y中间位置
    /// centerY: 视图Y的中间位置
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = self.center
            tempCenter.y = newValue
            self.center = tempCenter;
        }
    }
    
    // MARK: 3.9、top 上端横坐标(y)
    /// top 上端横坐标(y)
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.y = newValue
            self.frame = tempFrame
        }
    }
    
    // MARK: 3.10、left 左端横坐标(x)
    /// left 左端横坐标(x)
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.x = newValue
            self.frame = tempFrame
        }
    }
    
    // MARK: 3.11、bottom 底端纵坐标 (y + height)
    /// bottom 底端纵坐标 (y + height)
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set(newValue) {
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }
    
    // MARK: 3.12、right 底端纵坐标 (x + width)
    /// right 底端纵坐标 (x + width)
    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set(newValue) {
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }
    
    // MARK: 3.13、origin 点
    /// origin 点
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set(newValue) {
            var tempOrigin: CGPoint = self.frame.origin
            tempOrigin = newValue
            self.frame.origin = tempOrigin
        }
    }
}
