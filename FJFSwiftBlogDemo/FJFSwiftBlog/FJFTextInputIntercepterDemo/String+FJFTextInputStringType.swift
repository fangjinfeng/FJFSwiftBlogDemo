//
//  String+FJFTextInputStringType.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/19.
//

import Foundation
import UIKit

enum FJFTextInputStringType {
    case number     // 数字
    case letter     // 字母
    case chinese    // 汉字
    case emoji      // 表情
}

extension String {

    func fjf_isContainString(type: FJFTextInputStringType) -> Bool {
        return fjf_matchReqular(type: type)
    }

    func fjf_isContainEmoji() -> Bool {
        if fjf_matchReqular(type: .emoji) {
            return true
        }

        if self.fjf_containsEmoji {
            return true
        }
        
        if String.fjf_isEmoji(self) {
            return true
        }
        
        return false
    }

    /// 包含emoji表情
    private var fjf_containsEmoji: Bool {
        return contains { $0.isEmoji}
    }
    
    private func fjf_matchReqular(type: FJFTextInputStringType) -> Bool {
        var regularStr = ""
        switch type {
        case .number:
            regularStr = "^[0-9]*$"
        case .letter:
            regularStr = "^[A-Za-z]+$"
        case .chinese:
            regularStr = "^[\u{4e00}-\u{9fa5}]{0,}$"
        case .emoji:
            regularStr = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        }
        let regex = NSPredicate(format: "SELF MATCHES %s", regularStr)
        return regex.evaluate(with: self)
    }

    static func fjf_isEmoji(_ character: String?) -> Bool {

            if character == "" || character == "\n" {
                return false
            }

            let characterRender = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 1, height: 1))
            characterRender.text = character
            characterRender.backgroundColor = .black
            characterRender.sizeToFit()

            let rect: CGRect = characterRender.bounds
            UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)

            if let contextSnap: CGContext = UIGraphicsGetCurrentContext() {
                characterRender.layer.render(in: contextSnap)
            }

            let capturedImage: UIImage? = (UIGraphicsGetImageFromCurrentImageContext())
            UIGraphicsEndImageContext()
            var colorPixelFound: Bool = false

            let imageRef = capturedImage?.cgImage
            let width: Int = imageRef!.width
            let height: Int = imageRef!.height

            let colorSpace = CGColorSpaceCreateDeviceRGB()

            let rawData = calloc(width * height * 4, MemoryLayout<CUnsignedChar>.stride).assumingMemoryBound(to: CUnsignedChar.self)

            let bytesPerPixel: Int = 4
            let bytesPerRow: Int = bytesPerPixel * width
            let bitsPerComponent: Int = 8

            let context = CGContext(data: rawData, width: Int(width), height: Int(height), bitsPerComponent: Int(bitsPerComponent), bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)

            context?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: width, height: height))

            var x: Int = 0
            var y: Int = 0
            while y < height && !colorPixelFound {

                while x < width && !colorPixelFound {

                    let byteIndex: UInt  = UInt((bytesPerRow * y) + x * bytesPerPixel)
                    let red = CGFloat(rawData[Int(byteIndex)])
                    let green = CGFloat(rawData[Int(byteIndex+1)])
                    let blue = CGFloat(rawData[Int(byteIndex + 2)])

                    var h: CGFloat = 0.0
                    var s: CGFloat = 0.0
                    var b: CGFloat = 0.0
                    var a: CGFloat = 0.0

                    let c = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                    c.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

                    b = b / 255.0

                    if Double(b) > 0.0 {
                        colorPixelFound = true
                    }
                    x+=1
                }
                x = 0
                y += 1
        }
        return colorPixelFound
    }
}

extension Character {
    /// 简单的emoji是一个标量，以emoji的形式呈现给用户
    var isSimpleEmoji: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else {
            return false
        }
        return unicodeScalars.count == 1 &&
            (firstProperties.isEmojiPresentation ||
                firstProperties.generalCategory == .otherSymbol)
    }

    /// 检查标量是否将合并到emoji中
    var isCombinedIntoEmoji: Bool {
        return unicodeScalars.count > 1 &&
            unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }

    /// 是否为emoji表情
    /// - Note: http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
    var isEmoji: Bool {
        return isSimpleEmoji || isCombinedIntoEmoji
    }
}
