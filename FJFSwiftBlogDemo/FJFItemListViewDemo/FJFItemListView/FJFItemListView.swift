//
//  FJFItemListView.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/14.
//

import UIKit
import SnapKit

typealias FJFItemListViewItemClosure = (Int) -> UIView

class FJFItemListView: UIView {

    // 实际要展示的数据源
    private var viewMarray: [UIView] = [UIView]()
    // itemView 闭包
    var itemViewClosure: FJFItemListViewItemClosure?
    
    // MARK: - Life
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    public func setupView(itemCount: Int, itemHeight: Double, itemSpacing: Double, topSpacing: Double) {
        var tmpViewMarray: [UIView] = [UIView]()
        let curCount = itemCount
        let preCount = viewMarray.count
        
        // 当前数量 大于 数组容量
        if curCount > preCount {
            for index in 0 ..< curCount {
                var itemView: UIView? = nil
                // 当索引 小于 数组容量(直接从数组获取)
                if index < preCount {
                    itemView = viewMarray[index]
                } else { // 当索引数量 大于 数组容量
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
                    tmpView.frame = itemViewFrame(itemIndex: index, itemHeight: itemHeight, itemSpacing: itemSpacing, topSpacing: topSpacing)
                    tmpViewMarray.append(tmpView)
                }
            }
        }
        else {
            for (index, itemView) in viewMarray.enumerated() {
                if index < curCount {
                    itemView.isHidden = false
                } else {
                    itemView.isHidden = true
                }
                itemView.frame = itemViewFrame(itemIndex: index, itemHeight: itemHeight, itemSpacing: itemSpacing, topSpacing: topSpacing)
                tmpViewMarray.append(itemView)
            }
        }
        viewMarray = tmpViewMarray
    }
    
    // MARK: - Private
    private func itemViewFrame(itemIndex: Int, itemHeight: Double, itemSpacing: Double, topSpacing: Double) -> CGRect {
        let itemViewX = 0.0
        let itemViewY = topSpacing + (Double(itemIndex) * (itemHeight + itemSpacing))
        let itemViewWidth = self.frame.size.width
        let itemViewHeight = itemHeight
        return CGRect(x: itemViewX, y: itemViewY, width: itemViewWidth, height: itemViewHeight)
    }
    
    private func initItemView() -> UIView {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }
}
