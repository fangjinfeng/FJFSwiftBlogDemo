//
//  FJFItemAutoListView.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/15.
//

import UIKit
import SnapKit

struct FJFItemListViewStyle {
    var itemHeight: Double  = 0.0                // item高度
    var itemSpacing: Double = 0.0                // item之间间距
    var itemCount: Int = 0                       // item的数量
    
    var topSpacing: Double = 0.0                 // 第一个item顶部间距
    var bottomSpacing: Double = 0.0              // 最后一个item底部间距
    
    var listViewHeight: Double {
        return topSpacing + (Double(itemCount) * (itemHeight * itemSpacing)) + bottomSpacing
    }
}

typealias FJFItemAutoListViewItemClosure = (Int) -> UIView


class FJFItemAutoListView: UIView {
    // 样式配置
    var viewStyle: FJFItemListViewStyle =  FJFItemListViewStyle()
    // 实际要展示的数据源
    var viewArray: [UIView] = [UIView]()
    // itemView 闭包
    var itemViewClosure: FJFItemAutoListViewItemClosure?
    
    // MARK: - Life
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    public func updateViewControls(viewStyle: FJFItemListViewStyle) {
        self.viewStyle = viewStyle
        self.updateViewControls()
    }
    
    public func updateViewControls() {
        var tmpViewMarray: [UIView] = [UIView]()
        let curCount = viewStyle.itemCount
        let preCount = viewArray.count
        
        var referView:UIView = self
        // 当前数量 大于 数组容量
        if curCount > preCount {
            for index in 0 ..< curCount {
                var itemView: UIView? = nil
                // 当索引 小于 数组容量(直接从数组获取)
                if index < preCount {
                    itemView = viewArray[index]
                } else { // 当索引数量 大于 数组容量(从外部创建)
                    if let closeure = self.itemViewClosure {
                        itemView = closeure(index)
                    } else {
                        itemView = initItemView()
                    }
                    if let tmpView = itemView {
                        self.addSubview(tmpView)
                    }
                }
                if let tmpView = itemView {
                    tmpView.isHidden = false
                    layoutItemView(referView: referView, itemView: tmpView, itemIndex: index, viewStyle: viewStyle)
                    referView = tmpView
                    tmpViewMarray.append(tmpView)
                }
            }
        }
        else {
            for (index, itemView) in viewArray.enumerated() {
                if index < curCount {
                    itemView.isHidden = false
                } else {
                    itemView.isHidden = true
                }
                layoutItemView(referView: referView, itemView: itemView, itemIndex: index, viewStyle: viewStyle)
                referView = itemView
                tmpViewMarray.append(itemView)
            }
        }
        viewArray = tmpViewMarray
    }
    
    // MARK: - Private
    private func layoutItemView(referView: UIView, itemView: UIView, itemIndex: Int, viewStyle: FJFItemListViewStyle) {
        if itemIndex == 0 {
            itemView.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(viewStyle.itemHeight)
                make.top.equalTo(referView).offset(viewStyle.topSpacing)
            }
        } else {
            itemView.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(viewStyle.itemHeight)
                make.top.equalTo(referView.snp.bottom).offset(viewStyle.itemSpacing)
            }
        }
    }
    
    private func initItemView() -> UIView {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }
}
