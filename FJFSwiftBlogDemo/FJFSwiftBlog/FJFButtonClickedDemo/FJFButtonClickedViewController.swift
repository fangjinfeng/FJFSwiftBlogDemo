//
//  FJFButtonClickedViewController.swift
//  FJFSwiftBlogDemo
//
//  Created by peakfang on 2022/6/20.
//

import UIKit

class FJFButtonClickedViewController: UIViewController {

    // MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "按键点击响应问题"
        self.view.backgroundColor = .white
        self.view.addSubview(testView)
        testView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(140)
        }
    }
    
    @objc
    func testButtonClicked(_ sender: UIButton) {
        print("-----------------------:FJFButtonClickedViewController")
    }
    // MARK: - Lazy
    lazy var testView: FJFButtonTestView = {
        let view = FJFButtonTestView()
        view.backgroundColor = .blue
        return view
    }()

}
