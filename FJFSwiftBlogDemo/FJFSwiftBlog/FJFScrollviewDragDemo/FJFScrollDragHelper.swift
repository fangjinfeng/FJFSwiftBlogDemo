//
//  FJFScrollDragHelper.swift
//  FJFSwiftBlogDemo
//
//  Created by peakfang on 2023/7/26.
//

import UIKit

/// 当前 滚动 视图 类型
public enum FJFCurrentScrollViewType {
    case externalView /// 外部 视图
    case insideView   /// 内部 视图
    case all   /// 内部外部都可以响应
}

/// 当前 滚动 视图  位置 属性
public enum FJFScrollViewPositionType {
    case top      /// 顶部
    case middle   /// 中间
    case bottom   /// 底部
}

class FJFScrollDragHelper: NSObject {
    /// scrollView 显示高度
    public var scrollViewHeight: CGFloat = kScreenH
    /// 限制的高度(超过这个高度可以滚动)
    public var kScrollLimitHeight: CGFloat = kScreenH * 0.51
    /// 滑动初始速度(大于该速度直接滑动到顶部或底部)
    public var slideInitSpeedLimit: CGFloat = 3500.0
    /// 当前 滚动 视图 位置
    public var curScrollViewPositionType: FJFScrollViewPositionType = .middle
    /// 最高 展示 高度
    public var topShowHeight: CGFloat = 0
    /// 中间 展示 高度
    public var middleShowHeight: CGFloat = 0
    /// 最低 展示 高度
    public var lowestShowHeight: CGFloat = 0
    /// 当前 滚动 视图 类型
    private var currentScrollType: FJFCurrentScrollViewType = .externalView
    /// 外部 滚动 view
    public weak var externalScrollView: UIScrollView?
    /// 内部 滚动 view
    public weak var insideScrollView: UIScrollView?
    /// 拖动 scrollView 回调
    public var panScrollViewBlock: (() -> Void)?
    /// 移动到顶部
    public var goToTopPosiionBlock: (() -> Void)?
    /// 移动到 底部 默认位置
    public var goToLowestPosiionBlock: (() -> Void)?
    /// 移动到 中间 默认位置
    public var goToMiddlePosiionBlock: (() -> Void)?
    
    // MARK: - Public
    /// 添加 滑动 手势 到 外部滚动视图
    public func addPanGestureRecognizer(externalScrollView: UIScrollView){
        let panRecoginer = UIPanGestureRecognizer(target: self, action: #selector(panScrollViewHandle(pan:)))
        externalScrollView.addGestureRecognizer(panRecoginer)
        self.externalScrollView = externalScrollView
    }
    
    /// 更新 滚动 类型 当滚动的时候，并返回是否立即停止滚动
    public func isNeedToStopScrollAndUpdateScrollType(scrollView: UIScrollView) -> Bool {
        if scrollView == self.insideScrollView {
            /// 当前滚动的是外部视图
            if self.currentScrollType == .externalView {
                self.insideScrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                return true
            }
            if self.curScrollViewPositionType == .top {
                if self.currentScrollType == .all { /// 在顶部的时候，外部和内部视图都可以滑动，判断当内部滚动视图视图的位置，如果滚动到底部了，则变为外部滚动视图跟着滑动，内部滚动视图不动
                    if scrollView.contentOffset.y <= 0 {
                        self.currentScrollType = .externalView
                    } else {
                        self.currentScrollType = .insideView
                    }
                } else if scrollView.isDecelerating == false,
                    self.currentScrollType == .insideView { /// 在顶部的时候，当内部滚动视图，慢慢滑动到底部，变成整个外部滚动视图跟着滑动下来，内部滚动视图不再滑动
                    if scrollView.contentOffset.y <= 0 {
                        self.currentScrollType = .externalView
                    }
                }
            }
        }
        return false
    }
    
    /// 更新 当前 滚动类型 当开始拖动 (当在顶部，开始滑动时候，判断当前滑动的对象是内部滚动视图，还是外部滚动视图)
    public func updateCurrentScrollTypeWhenBeginDragging(_ scrollView: UIScrollView) {
        if self.curScrollViewPositionType == .top {
            if scrollView.contentOffset.y <= 0 {
                self.currentScrollType = .externalView
            } else {
                self.currentScrollType = .insideView
            }
        }
    }

    /// 当在顶部，滚动停止时候 更新 当前 滚动类型 ，如果当前内部滚动视图，已经滚动到最底部，
    /// 则只能滚动最外层滚动视图，如果内部滚动视图没有滚动到最底部，则外部和内部视图都可以滚动
    public func updateCurrentScrollTypeWhenScrollEnd(_ scrollView: UIScrollView) {
        if self.curScrollViewPositionType == .top {
            if scrollView.contentOffset.y <= 0 {
                self.currentScrollType = .externalView
            } else {
                self.currentScrollType = .all
            }
        }
    }
    
    /// 获取顶部位置 距离顶部 距离
    public func getTopPositionToTopDistance() -> CGFloat {
        return self.scrollViewHeight - self.topShowHeight
    }
    /// 获取 中间 位置 距离 顶部 距离
    public func getMiddlePositionToTopDistance() -> CGFloat {
        return self.scrollViewHeight - self.middleShowHeight
    }
    /// 获取 底部 位置 距离 顶部 距离
    public func getBottomPositionToTopDistance() -> CGFloat {
        return self.scrollViewHeight - self.lowestShowHeight
    }
    /// 获取 是否 滚动 到顶部
    public func getIsScrollToTop() -> Bool {
        return self.curScrollViewPositionType == .top
    }
    /// 判断 是否 需要 滚动到底部
    public func judgeNeedScrollToBottom() {
        if self.curScrollViewPositionType == .middle {
            self.gotoLowestPosition()
        }
    }
    // MARK: - Actions
    /// tableView 手势
    @objc
    private func panScrollViewHandle(pan: UIPanGestureRecognizer) {
        /// 当前 滚动 内部视图 不响应拖动手势
        if self.currentScrollType == .insideView {
            return
        }
        guard let contentScrollView = self.externalScrollView else {
            return
        }
        let translationPoint = pan.translation(in: contentScrollView.superview)

        // contentScrollView.top 视图距离顶部的距离
        contentScrollView.y += translationPoint.y
        /// contentScrollView 移动到顶部
        let distanceToTopH = self.getTopPositionToTopDistance()
        if contentScrollView.y < distanceToTopH {
            contentScrollView.y = distanceToTopH
            self.curScrollViewPositionType = .top
            self.currentScrollType = .all
        }
        /// 视图在底部时距离顶部的距离
        let distanceToBottomH = self.getBottomPositionToTopDistance()
        if contentScrollView.y > distanceToBottomH {
            contentScrollView.y = distanceToBottomH
            self.curScrollViewPositionType = .bottom
            self.currentScrollType = .externalView
        }
        /// 拖动 回调 用来 更新 遮罩
        self.panScrollViewBlock?()
        // 在滑动手势结束时判断滑动视图距离顶部的距离是否超过了屏幕的一半，如果超过了一半就往下滑到底部
        // 如果小于一半就往上滑到顶部
        if pan.state == .ended || pan.state == .cancelled {
            
            // 处理手势滑动时，根据滑动速度快速响应上下位置
            let velocity = pan.velocity(in: contentScrollView)
            let largeSpeed = self.slideInitSpeedLimit
            /// 超过 最大 力度
            if velocity.y < -largeSpeed {
                gotoTheTopPosition()
                pan.setTranslation(CGPoint(x: 0, y: 0), in: contentScrollView)
                return
            } else if velocity.y < 0, velocity.y > -largeSpeed {
                if self.curScrollViewPositionType == .bottom {
                    gotoMiddlePosition()
                } else {
                    gotoTheTopPosition()
                }
                pan.setTranslation(CGPoint(x: 0, y: 0), in: contentScrollView)
                return
            } else if velocity.y > largeSpeed {
                gotoLowestPosition()
                pan.setTranslation(CGPoint(x: 0, y: 0), in: contentScrollView)
                return
            } else if velocity.y > 0, velocity.y < largeSpeed {
                if self.curScrollViewPositionType == .top {
                    gotoMiddlePosition()
                } else {
                    gotoLowestPosition()
                }
                pan.setTranslation(CGPoint(x: 0, y: 0), in: contentScrollView)
                return
            }
            let scrollViewDistanceToTop = kScreenH - contentScrollView.top
            let topAndMiddleMeanValue = (self.topShowHeight + self.middleShowHeight) / 2.0
            let middleAndBottomMeanValue = (self.middleShowHeight + self.lowestShowHeight) / 2.0
            
            if scrollViewDistanceToTop >= topAndMiddleMeanValue {
                gotoTheTopPosition()
            } else if scrollViewDistanceToTop < topAndMiddleMeanValue,
                    scrollViewDistanceToTop > middleAndBottomMeanValue {
                gotoMiddlePosition()
            } else {
                gotoLowestPosition()
            }
        }
        pan.setTranslation(CGPoint(x: 0, y: 0), in: contentScrollView)
    }
    
    // MARK: - Private
    /// 回到 顶部 位置
    private func gotoTheTopPosition() {
        self.curScrollViewPositionType = .top
        self.goToTopPosiionBlock?()
    }
    
    /// 回到 中间 位置
    private func gotoMiddlePosition() {
        self.curScrollViewPositionType = .middle
        self.goToMiddlePosiionBlock?()
    }
    
    /// 回到 底部 位置
    private func gotoLowestPosition() {
        self.curScrollViewPositionType = .bottom
        self.goToLowestPosiionBlock?()
    }
}
