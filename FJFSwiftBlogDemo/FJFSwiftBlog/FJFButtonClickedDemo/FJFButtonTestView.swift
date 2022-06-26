//
//  FJFButtonTestView.swift
//  FJFSwiftBlogDemo
//
//  Created by peakfang on 2022/6/20.
//

import UIKit
import SnapKit

class FJFButtonTestView: UIView {

    // MARK: - Life
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewControls()
        layoutViewControls()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Response
    @objc
    func testButtonClicked(_ sender: UIButton) {
        print("-----------------------:FJFButtonTestView")
    }
    // MARK: - Private
    private func setupViewControls() {
        self.addSubview(testButton)
    }
    
    private func layoutViewControls() {
        testButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(80)
        }
    }
    
    // MARK: - Lazy
    var testButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("点击", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(testButtonClicked), for: .touchUpInside)
        return btn
    }()
}
