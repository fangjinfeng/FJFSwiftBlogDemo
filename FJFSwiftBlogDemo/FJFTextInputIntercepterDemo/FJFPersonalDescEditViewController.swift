//
//  FJFPersonalDescEditViewController.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/20.
//

import UIKit

class FJFPersonalDescEditViewController: UIViewController {

    // MARK: - Life
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(introduceTextView)
        introduceTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(12)
            make.height.equalTo(250)
        }
        
        self.title = "修改个人简介"
        self.view.backgroundColor = .white
    }
    
    // MARK: - Lazy
    lazy var introduceTextView: UITextView = {
        let tf = UITextView.init(frame: CGRect.zero)
        tf.font = UIFont.systemFont(ofSize: 12)
        tf.tintColor = .blue
        tf.text = "孩子，我要求你读书用功，不是因为我要你跟别人比成绩，而是因为，我希望你将来会拥有选择的权利，选择有意义、有时间的工作，而不是被迫谋生。当你的工作在你心中有意义，你就有成就感。当你的工作给你时间，不剥夺你的生活，你就有尊严。成就感和尊严，给你快乐。"
        
        let intercepter = FJFTextInputIntercepter.init()
        intercepter.maxCharacterNum = 100
        intercepter.isEmojiAdmitted = false
        intercepter.isDoubleBytePerChineseCharacter = true
        intercepter.textInputView(inputView: tf)
        intercepter.updateText(inputView: tf)
        intercepter.inputBlock = { [weak self] (textIntercepter, string) in
            
        }
        return tf
    }()
}
