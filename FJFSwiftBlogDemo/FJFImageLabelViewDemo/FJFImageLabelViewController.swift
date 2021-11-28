//
//  FJFImageLabelViewController.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/29.
//

import UIKit

class FJFImageLabelViewController: UIViewController {

    // MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(self.imageLabelView)
        imageLabelView.snp.makeConstraints { make in
            make.centerY.equalTo(self.view)
            make.centerX.equalTo(self.view)
            make.width.equalTo(80)
            make.height.equalTo(60)
        }
        imageLabelView.backgroundColor = .red
        self.title = "imageLabelView"
        self.view.backgroundColor = .white
    }
    
    // MARK: - Lazy
    lazy var imageLabelView: FJFImageLabelView = {
        let imageLabelView = FJFImageLabelView.init()
        imageLabelView.viewStyle.isUserInteractionEnabled = false
        imageLabelView.viewStyle.title = "添加"
        imageLabelView.viewStyle.layoutType = .leftRight
        imageLabelView.viewStyle.edgeSpacing = 12
        imageLabelView.viewStyle.contentAlignment = .right
        imageLabelView.viewStyle.imageSize = CGSize.init(width: 14, height: 14)
        imageLabelView.viewStyle.iconImage = UIImage.init(named: "fjf_address_add_icon")
        imageLabelView.updateViewControls()
        imageLabelView.tapViewClosure = { [weak self] (sender) in
            
        }
        return imageLabelView
    }()

}
