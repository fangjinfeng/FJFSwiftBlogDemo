//
//  FJFImageLabelView.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/15.
//

import UIKit
import SnapKit

enum FJFImageLabelType {
    case upDown     //图标上，文字下
    case downUp     //图标下，文字上
    case leftRight  //图标左，文字右
    case rightLeft  //图标右，文字左
}

private let kInvalidValue: Float = -999

struct FJFImageLabelViewStyle {
    var layoutType: FJFImageLabelType =  .upDown                                // item高度
    var contentAlignment: NSTextAlignment = .center                             // 对齐方式
    var itemSpacing: Float = 2                                                 // label和image之间间距
    var topSpacing: Float = kInvalidValue                                      // 顶部间距
    var edgeSpacing: Float = 6                                                 // 左右边距(依据对齐方式来设置)
    var title: String = ""                                                      // 标题
    var iconImage: UIImage?                                                     // 图标
    var imageSize: CGSize = CGSize.init(width: 0, height: 0)                    // 图片大小
    var labelTextColor: UIColor = UIColor.black.withAlphaComponent(0.85)        // 文本颜色
    var labelFont: UIFont = UIFont.systemFont(ofSize: 12)                       // 字体大小
    var isUserInteractionEnabled: Bool = false                                  // 是否响应
    
    var contentWidth: Float {
        return Float(imageSize.width) + itemSpacing + FJFImageLabelView.titleWidth(title: title, font: labelFont)
    }
    
    var titleWidth: Float {
        return FJFImageLabelView.titleWidth(title: title, font: labelFont)
    }
    
    var titleHeight: Float {
        return FJFImageLabelView.titleHeight(title: title, font: labelFont)
    }
}

typealias FJFImageLabelViewTapClosure = (UIView?) -> Void

class FJFImageLabelView: UIView {

    var viewStyle: FJFImageLabelViewStyle =  FJFImageLabelViewStyle()     // 样式配置
    
    // 点击 回调 闭包
    var tapViewClosure: FJFImageLabelViewTapClosure?
    
    // MARK: - Life
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewControls()
    }
    
                                           
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    public func updateViewControls() {
        self.updateViewControls(viewStyle: self.viewStyle)
    }
    
    
    public func updateViewControls(viewStyle: FJFImageLabelViewStyle) {
        self.viewStyle = viewStyle
        
        self.isUserInteractionEnabled = viewStyle.isUserInteractionEnabled
        
        titleLab.text = viewStyle.title
        titleLab.font = viewStyle.labelFont
        titleLab.textColor = viewStyle.labelTextColor
        
        if let image = viewStyle.iconImage {
            iconImageView.image = image
        }
        switch viewStyle.layoutType {
        case .upDown:
            layoutUpDown()
        case .downUp:
            layoutDownUp()
        case .leftRight:
            layoutLeftRight()
        case .rightLeft:
            layoutRightLeft()
        }
    }
    
    // MARK: - Private
    private func setupViewControls() {
        self.addSubview(titleLab)
        self.addSubview(iconImageView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func layoutUpDown() {
        iconImageView.snp.remakeConstraints { (make) in
            if viewStyle.topSpacing != kInvalidValue {
                make.top.equalTo(viewStyle.topSpacing)
            } else {
                make.centerY.equalTo(self.snp.centerY).offset(-viewStyle.imageSize.height/2.0)
            }
            make.centerX.equalTo(self.titleLab)
            make.size.equalTo(viewStyle.imageSize)
        }
        
        titleLab.snp.remakeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(viewStyle.itemSpacing)
            if viewStyle.contentAlignment == .left {
                make.leading.equalTo(self).offset(viewStyle.edgeSpacing)
            } else if(viewStyle.contentAlignment == .right) {
                make.trailing.equalTo(self).offset(-viewStyle.edgeSpacing)
            } else {
                make.centerX.equalToSuperview()
            }
            make.width.height.greaterThanOrEqualTo(0)
        }
    }
    
    private func layoutDownUp() {
        titleLab.snp.remakeConstraints { (make) in
            if viewStyle.topSpacing != kInvalidValue {
                make.top.equalTo(viewStyle.topSpacing)
            } else {
                make.centerY.equalTo(self.snp.centerY).offset(-viewStyle.titleHeight/2.0)
            }
            if viewStyle.contentAlignment == .left {
                make.leading.equalTo(self).offset(viewStyle.edgeSpacing)
            } else if(viewStyle.contentAlignment == .right) {
                make.trailing.equalTo(self).offset(-viewStyle.edgeSpacing)
            } else {
                make.centerX.equalToSuperview()
            }
            make.width.height.greaterThanOrEqualTo(0)
        }
        
        iconImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(viewStyle.itemSpacing)
            make.centerX.equalTo(self.titleLab)
            make.size.equalTo(viewStyle.imageSize)
        }
    }
    
    // 图片在左 文本在右
    private func layoutLeftRight() {
        
        if viewStyle.contentAlignment == .left {
            iconImageView.snp.remakeConstraints { (make) in
                if viewStyle.topSpacing != kInvalidValue {
                    make.top.equalTo(viewStyle.topSpacing)
                } else {
                    make.centerY.equalTo(self.snp.centerY)
                }
                make.leading.equalTo(self).offset(viewStyle.edgeSpacing)
                make.size.equalTo(viewStyle.imageSize)
            }
            
            titleLab.snp.remakeConstraints { (make) in
                make.leading.equalTo(iconImageView.snp.trailing).offset(viewStyle.itemSpacing)
                make.centerY.equalTo(self.iconImageView)
                make.width.height.greaterThanOrEqualTo(0)
            }
            
        } else if(viewStyle.contentAlignment == .right) {
            titleLab.snp.remakeConstraints { (make) in
                if viewStyle.topSpacing != kInvalidValue {
                    make.top.equalTo(viewStyle.topSpacing)
                } else {
                    make.centerY.equalTo(self.snp.centerY)
                }
                make.trailing.equalTo(self).offset(-viewStyle.edgeSpacing)
            }
            
            iconImageView.snp.remakeConstraints { (make) in
                if viewStyle.topSpacing != kInvalidValue {
                    make.top.equalTo(viewStyle.topSpacing)
                } else {
                    make.centerY.equalTo(self.snp.centerY)
                }
                make.trailing.equalTo(titleLab.snp.leading).offset(-viewStyle.itemSpacing)
                make.size.equalTo(viewStyle.imageSize)
            }
            
        } else {
            let contentWidth = viewStyle.titleWidth
            let imageOffset = contentWidth / 2.0
            iconImageView.snp.remakeConstraints { (make) in
                if viewStyle.topSpacing != kInvalidValue {
                    make.top.equalTo(viewStyle.topSpacing)
                } else {
                    make.centerY.equalTo(self.snp.centerY)
                }
                make.centerX.equalToSuperview().offset(-imageOffset)
                make.size.equalTo(viewStyle.imageSize)
            }
            
            titleLab.snp.remakeConstraints { (make) in
                make.leading.equalTo(iconImageView.snp.trailing).offset(viewStyle.itemSpacing)
                make.centerY.equalTo(self.iconImageView)
                make.width.height.greaterThanOrEqualTo(0)
            }
        }
    }
    
    // 文本在左，图片在右
    private func layoutRightLeft() {
        if viewStyle.contentAlignment == .left {
            titleLab.snp.remakeConstraints { (make) in
                if viewStyle.topSpacing != kInvalidValue {
                    make.top.equalTo(viewStyle.topSpacing)
                } else {
                    make.centerY.equalTo(self.snp.centerY)
                }
                make.leading.equalTo(self).offset(viewStyle.edgeSpacing)
                make.width.height.greaterThanOrEqualTo(0)
            }
            
            iconImageView.snp.remakeConstraints { (make) in
                make.leading.equalTo(titleLab.snp.trailing).offset(viewStyle.itemSpacing)
                make.centerY.equalTo(self.titleLab)
                make.size.equalTo(viewStyle.imageSize)
            }
            
        } else if(viewStyle.contentAlignment == .right) {
            
            iconImageView.snp.remakeConstraints { (make) in
                if viewStyle.topSpacing != kInvalidValue {
                    make.top.equalTo(viewStyle.topSpacing)
                } else {
                    make.centerY.equalTo(self.snp.centerY)
                }
                make.size.equalTo(viewStyle.imageSize)
                make.trailing.equalTo(self).offset(-viewStyle.edgeSpacing)
            }
            
            titleLab.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self.iconImageView)
                make.trailing.equalTo(iconImageView.snp.leading).offset(-viewStyle.itemSpacing)
                make.width.height.greaterThanOrEqualTo(0)
            }
            
        } else {
            let contentWidth = viewStyle.imageSize.width
            let imageOffset = contentWidth / 2.0
            titleLab.snp.remakeConstraints { (make) in
                if viewStyle.topSpacing != kInvalidValue {
                    make.top.equalTo(viewStyle.topSpacing)
                } else {
                    make.centerY.equalTo(self.snp.centerY)
                }
                make.centerX.equalToSuperview().offset(imageOffset)
                make.width.height.greaterThanOrEqualTo(0)
            }
            
            iconImageView.snp.remakeConstraints { (make) in
                make.trailing.equalTo(titleLab.snp.leading).offset(-viewStyle.itemSpacing)
                make.centerY.equalTo(self.titleLab)
                make.size.equalTo(viewStyle.imageSize)
            }
        }
    }
    
    class func titleWidth(title: String, font: UIFont) -> Float {
        let size = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).size
        return Float(size.width)
    }
    
    class func titleHeight(title: String, font: UIFont) -> Float {
        let size = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).size
        return Float(size.height)
    }
    
    // MARK: - response
    @objc
    func tapAction(_ tap: UITapGestureRecognizer) {
        if let closeure = self.tapViewClosure {
            closeure(tap.view ?? nil)
        }
    }

    // MARK: - lazy
    //标题
    lazy var titleLab:UILabel = {
        let lable = UILabel.init()
        lable.textColor = UIColor.black.withAlphaComponent(0.85)
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.isUserInteractionEnabled = false
        return lable
    }()
    
    //图标
    lazy var iconImageView:UIImageView = {
        let imageView = UIImageView.init()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
}
