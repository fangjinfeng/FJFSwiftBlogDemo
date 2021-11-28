//
//  FJFPersonListModel.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/29.
//


import Foundation
import HandyJSON


// 地址 item 类型
struct FJFPersonListModel: HandyJSON {
    var addressDetails: [FJFPersonInfoModel]?
    
    static func defaultData() -> [FJFPersonInfoModel] {
        return [
            FJFPersonInfoModel.init(address: "广东省深圳市宝安区福永路198号", cityName: "深圳", sex: "男", name: "王招商"),
            FJFPersonInfoModel.init(address: "广东省深圳市宝安区福永路198号", cityName: "深圳", sex: "男", name: "董大"),
            FJFPersonInfoModel.init(address: "广东省深圳市宝安区福永路198号", cityName: "深圳", sex: "男", name: "楚才"),
            FJFPersonInfoModel.init(address: "广东省深圳市宝安区福永路198号", cityName: "深圳", sex: "男", name: "王大"),
            FJFPersonInfoModel.init(address: "广东省深圳市宝安区福永路198号", cityName: "深圳", sex: "男", name: "王五"),
            FJFPersonInfoModel.init(address: "广东省深圳市宝安区福永路198号", cityName: "深圳", sex: "男", name: "李四"),
                ]
    }
}

// 个人信息 item 类型
struct FJFPersonInfoModel: HandyJSON {
    var address: String?
    var cityName: String?
    var sex: String?
    var name: String?
}
