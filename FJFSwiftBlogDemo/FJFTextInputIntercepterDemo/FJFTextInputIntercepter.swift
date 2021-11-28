//
//  FJFTextInputIntercepter.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/19.
//

import UIKit

typealias TextInputIntercepterBlock = (FJFTextInputIntercepter, String) -> Void

enum TextInputIntercepterNumberType {
    /// 非数字
    case none
    /// 只允许 数字
    case numberOnly
    /// 小数的 (默认 两位 小数) 十进制的
    case decimal
}

class FJFTextInputIntercepter: NSObject, UITextFieldDelegate, UITextViewDelegate {
    /// maxCharacterNum 限制最大字符
    public var maxCharacterNum: UInt = UInt.max

    /// 小数点位数(当intercepterNumberType 为.decimal 有用)
    public var decimalPlaces: UInt = 0

    /// inputBlock 输入 回调处理
    public var inputBlock: TextInputIntercepterBlock?

    /// beyoudLimitBlock 超过限制最大字符数回调
    public var beyondLimitBlock: TextInputIntercepterBlock?

    /// 是否允许输入表情
    public var isEmojiAdmitted: Bool = false

    /// numberTypeDecimal 小数
    public var intercepterNumberType: TextInputIntercepterNumberType = .none {
        didSet {
            if intercepterNumberType == .decimal && decimalPlaces == 0 {
                decimalPlaces = 2
            }
            if intercepterNumberType != .none {
                isDoubleBytePerChineseCharacter = false
            }
        }
    }

    /* default false
     isDoubleBytePerChineseCharacter 为 false
     字母、数字、汉字都是1个字节 表情是两个字节
     isDoubleBytePerChineseCharacter 为 true
     不允许输入表情 一个汉字代表2个字节 使用GB_18030_2000编码
     允许输入表情 一个汉字代表3个字节 表情代表4个字节 使用UTF8编码
     */
    public var isDoubleBytePerChineseCharacter: Bool = false

    // 先前字符串 用于比较(previousText)
    private var previousText: String = ""

    // MARK: - Class

    /// 生成输入框拦截器
    /// - Parameters:
    ///   - textInputView: 输入框
    ///   - beyondLimitBlock: 超时限制回调
    /// - Returns: 拦截器
    class func textInputView(textInputView: UIView, beyondLimitBlock: @escaping TextInputIntercepterBlock) -> FJFTextInputIntercepter {
        let tempInputIntercepter = FJFTextInputIntercepter.init()
        tempInputIntercepter.beyondLimitBlock = beyondLimitBlock
        tempInputIntercepter.textInputView(textInputView: textInputView, intercepter: tempInputIntercepter)
        return tempInputIntercepter
    }

    // MARK: - Public

    /// 设置 需要 拦截的输入框
    /// - Parameter inputView: 输入框
    public func textInputView(inputView: UIView) {
        textInputView(textInputView: inputView, intercepter: self)
    }

    /// 设置 拦截器和拦截的输入框
    /// - Parameters:
    ///   - textInputView: 输入框
    ///   - intercepter: 拦截器
    public func textInputView(textInputView: UIView, intercepter: FJFTextInputIntercepter) {
        if textInputView is UITextField {
            let textField = textInputView as! UITextField
            textField.delegate = self
            textField.fjf_textInputIntercepter = intercepter
            NotificationCenter.default.addObserver(self, selector: #selector(textInputDidChange(noti:)), name: UITextField.textDidChangeNotification, object: textInputView)

        } else if textInputView is UITextView {
            let textView = textInputView as! UITextView
            textView.delegate = self
            textView.fjf_textInputIntercepter = intercepter
            NotificationCenter.default.addObserver(self, selector: #selector(textInputDidChange(noti:)), name: UITextView.textDidChangeNotification, object: textInputView)
        }
    }
    
    // 更新 文本
    public func updateText(inputView: UIView) {
        if inputView is UITextField {
            if let textField = inputView as? UITextField {
                updateTextFieldWithTextField(textField: textField)
            }
        }
        else if inputView is UITextView {
            if let textView = inputView as? UITextView {
                updateTextViewWithTextView(textView: textView)
            }
        }
    }
    
    // MARK: - Noti

    /// 输入框改变通知
    /// - Parameter noti: 通知
    @objc func textInputDidChange(noti: Notification) {
        if let obj = noti.object as? UIView {
            if obj.isFirstResponder == false {
                return
            }
        }
        let isTextField = noti.object is UITextField
        let isTextFieldTextDidChange: Bool = noti.name == UITextField.textDidChangeNotification && isTextField

        let isTextView = noti.object is UITextView
        let isTextViewTextDidChange: Bool = noti.name == UITextView.textDidChangeNotification && isTextView

        if isTextFieldTextDidChange {
            if let textField = noti.object as? UITextField {
                updateTextFieldWithTextField(textField: textField)
            }
        }
        else if isTextViewTextDidChange {
            if let textView = noti.object as? UITextView {
                updateTextViewWithTextView(textView: textView)
            }
        }
    }
    
    // MARK: - Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let primaryLanguage = textField.textInputMode?.primaryLanguage ?? ""
        return isAllowedInput(replaceRange: range, replaceText: string, previousText: textField.text ?? "", primaryLanguage: primaryLanguage)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let primaryLanguage = textView.textInputMode?.primaryLanguage ?? ""
        return isAllowedInput(replaceRange: range, replaceText: text, previousText: textView.text, primaryLanguage: primaryLanguage)
    }
}

extension FJFTextInputIntercepter {

    // MARK: Private
    func updateTextFieldWithTextField(textField: UITextField) {
        let fieldText = textField.text ?? ""
        if isBeyondLimit(inputText: fieldText as NSString) {
            textField.text = handleInputText(inputText: fieldText as NSString) as String
            beyondLimitBlock?(self, textField.text ?? "")
        }
        
        inputBlock?(self, textField.text ?? "")
    }

    func updateTextViewWithTextView(textView: UITextView) {
        let fieldText = textView.text ?? ""
        if isBeyondLimit(inputText: fieldText as NSString) {
            textView.text = handleInputText(inputText: fieldText as NSString) as String
            beyondLimitBlock?(self, textView.text ?? "")
        }
        
        inputBlock?(self, textView.text ?? "")
    }

    
    // 处理 字符串
    private func handleInputText(inputText: NSString) -> NSString {
        if isEmojiAdmitted {
            // 调用 UTF8 编码处理 一个字符一个字节 一个汉字3个字节 一个表情4个字节
            let textBytesLength = inputText.lengthOfBytes(using: String.Encoding.utf8.rawValue)
            if textBytesLength > maxCharacterNum {
                var range: NSRange = NSRange.init()
                var byteLength: UInt = 0
                var finalString = inputText
                let text = inputText
                var i = 0
                while i < inputText.length && byteLength <= maxCharacterNum {
                    range = inputText.rangeOfComposedCharacterSequence(at: i)
                    byteLength = byteLength + UInt(text.substring(with: range).count)
                    if byteLength > maxCharacterNum {
                        let newText = text.substring(with: NSRange(location: 0, length: range.location))
                        finalString = newText as NSString
                    }
                    i += range.length
                }
                return finalString
            }
        }
        else if isDoubleBytePerChineseCharacter {
            // GB_18030_2000 编码 (ASCII部分为单字节(数字，字母单字节))，汉字
            let cfEnc = CFStringEncodings.GB_18030_2000
            let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
            if let data = inputText.data(using: encoding) as NSData? {
                let length = data.length
                if length > maxCharacterNum {
                    let tempLength = maxCharacterNum
                    var subdata = data.subdata(with: NSRange.init(location: 0, length: Int(tempLength)))
                    var content = NSString.init(data: subdata, encoding: encoding)
                    // 注意：当截取CharacterCount长度字符时把中文字符截断返回的content会是nil
                    if  content == nil || content?.length == 0 {
                        subdata = data.subdata(with: NSRange.init(location: 0, length: Int(tempLength-1)))
                        content = NSString.init(data: subdata, encoding: encoding)
                    }
                    return content ?? inputText
                }
            }
        }
        else {
            if inputText.length > maxCharacterNum {
                var processingText: String?
                let rangeIndex = inputText.rangeOfComposedCharacterSequence(at: Int(maxCharacterNum))
                if rangeIndex.length == 1 {
                    processingText = inputText.substring(to: Int(maxCharacterNum))
                } else {

                    let tempRange = NSRange.init(location: 0, length: Int(maxCharacterNum))
                    let range: NSRange = inputText.rangeOfComposedCharacterSequences(for: tempRange)
                    processingText = inputText.substring(with: range)
                }
                if let process = processingText {
                    return process as NSString
                }
            }
        }
        return inputText
    }
    
    
    // 是否 允许 输入
    private func isAllowedInput(replaceRange: NSRange, replaceText: String, previousText: String, primaryLanguage: String) -> Bool{
        let newString = (previousText as NSString).replacingCharacters(in: replaceRange, with: replaceText as String)
        
        // 如果 是删除 字符 直接返回true
        if newString.count < previousText.count {
            return true
        }
        
        if isAllowedInput(replaceText: replaceText as NSString, previousText: previousText as NSString, primaryLanguage: primaryLanguage as NSString) == false {
            return false
        }
        
        
        if isBeyondLimit(inputText: newString as NSString) {
            beyondLimitBlock?(self, newString)
            return false
        }
        return true
    }
    
    
    // 是否 超出字符限制
    private func isBeyondLimit(inputText: NSString) -> Bool {
        if isEmojiAdmitted {
            // 调用 UTF8 编码处理 一个字符一个字节 一个汉字3个字节 一个表情4个字节
            let textBytesLength = inputText.lengthOfBytes(using: String.Encoding.utf8.rawValue)
            if textBytesLength > maxCharacterNum {
                return true
            }
        }
        else if isDoubleBytePerChineseCharacter {
            // GB_18030_2000 编码 (ASCII部分为单字节(数字，字母单字节))，汉字
            let cfEnc = CFStringEncodings.GB_18030_2000
            let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
            if let data = inputText.data(using: encoding) as NSData? {
                let length = data.length
                if length > maxCharacterNum {
                    return true
                }
            }
        }
        else {
            if inputText.length > maxCharacterNum {
                return true
            }
        }
        return false
    }
    
    private func isAllowedInput(replaceText: NSString, previousText: NSString, primaryLanguage: NSString) -> Bool {
        // 只允许输入数字
        if intercepterNumberType == .numberOnly {
            return (replaceText as String).fjf_isContainString(type: .number)
        }
            // 输入 小数
        else if intercepterNumberType == .decimal {
            let tmpRange = NSRange.init(location: previousText.length, length: 0)
            return inputTextShouldChangeCharacters(inputText: previousText, InRange: tmpRange, replacementString: replaceText)
        }
        // 不允许输入表情
        else if isEmojiAdmitted == false {
            return !isContainEmoji(primaryLanguage: primaryLanguage, replacementString: replaceText)
        }
        return true
    }
    
    
    private func isContainEmoji(primaryLanguage: NSString, replacementString: NSString) -> Bool {
        if (replacementString as String).fjf_isContainEmoji() {
            return true
        }

        if primaryLanguage.length == 0 ||
            primaryLanguage.isEqual(to: "emoji") {
            return true
        }
        return false
    }

    private func inputTextShouldChangeCharacters(inputText: NSString, InRange range: NSRange, replacementString string: NSString) -> (Bool) {
        /// 是否有小数点
        var isHaveDot: Bool = true
        if string == " " {
            return false
        }

        if inputText.contains(".") == false {
            isHaveDot = false
        }

        if string.length > 0 {
            if string == ":" || string == ";"{
                return false
            }

            /// 当前输入的字符
            let single: unichar = string.character(at: 0)
            // 数字0到9对应的ASCLL值 48-59   : ASCLL==58 ; ASCLL==59
            if (single >= 48 && single <= 59) || UnicodeScalar(single) == "." {
                if inputText.length == 0 {
                    if UnicodeScalar(single) == "." {
                        return false
                    }
                }
                // 输入的字符是否是小数点
                if UnicodeScalar(single) == "." {
                    if !isHaveDot {
                        isHaveDot = true
                        return true
                    } else {
                        return false
                    }
                } else {
                    if isHaveDot {
                        let ran = inputText.range(of: ".")
                        if range.location - ran.location <= decimalPlaces {
                            return true
                        } else {
                            return false
                        }

                    } else {
                        return true
                    }
                }
            } else {// 输入的数据格式不正确
                return false
            }
        }
        return true
    }

}

struct RuntimeKey {
    static let fjf_textFieldIntercepterKey = UnsafeRawPointer.init(bitPattern: "fjf_textFieldIntercepter".hashValue)
    static let fjf_textViewIntercepterKey = UnsafeRawPointer.init(bitPattern: "fjf_textViewIntercepter".hashValue)
}

extension UITextField {
     var fjf_textInputIntercepter: FJFTextInputIntercepter? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.fjf_textFieldIntercepterKey!) as? FJFTextInputIntercepter
        }
        set(newValue) {
            objc_setAssociatedObject(self, RuntimeKey.fjf_textFieldIntercepterKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UITextView {

    var fjf_textInputIntercepter: FJFTextInputIntercepter? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.fjf_textViewIntercepterKey!) as? FJFTextInputIntercepter
        }
        set(newValue) {
            objc_setAssociatedObject(self, RuntimeKey.fjf_textViewIntercepterKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
