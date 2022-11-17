//
//  FJFLaunchManager.swift
//  FJFSwiftBlogDemo
//
//  Created by peakfang on 2022/9/13.
//

import UIKit

// 启动 任务
public typealias FJFLaunchTaskBlock = () -> Void

// 启动 任务 所属 类型
public enum FJFLaunchTaskBlongType {
    case mainQueue      // 主队列
    case asynQueue      // 异步队列
}

// 启动 任务 优先级 类型
public enum FJFLaunchTaskPriorityType: Int {
    case lowPriority = -1
    case defaultPriority = 0
    case highPriority = 1
    case highestPriority = 2
}

class FJFLaunchTask {
    // 任务执行代码，任务执行之后会将此属性置为nil
    public var taskBlock: FJFLaunchTaskBlock?
    // 任务 所属 类型
    public var taskBlongType: FJFLaunchTaskBlongType
    // 任务 优先级 类型
    public var taskPriorityType: FJFLaunchTaskPriorityType
    
    public required init(_ taskBlock: FJFLaunchTaskBlock?,
                         _ taskBlongType: FJFLaunchTaskBlongType,
                         _ taskPriorityType: FJFLaunchTaskPriorityType = .defaultPriority) {
        self.taskBlock = taskBlock
        self.taskBlongType = taskBlongType
        self.taskPriorityType = taskPriorityType
    }
}

public class FJFLaunchManager {
    // Mark - Variable
    static public let shared = FJFLaunchManager()
    /// 是否开始执行延迟任务
    private var isStartExecDelayTask = false
    /// 是否runloop空闲去执行 延迟耗时任务
    private var isRunloopIdleExecDelayTask = true
    /// 当前手机版本是否低于马达指定版本(默认不低于)
    private var isLowMdapAssignPhoneVersion = false
    /// 马达指定低版本(低于此版本都为低版本)
    private var lowPhoneVersionLimit = 11
    /// 主队列
    private var main_queue = DispatchQueue.main
    /// 启动任务 异步执行队列
    private let asyn_queue = DispatchQueue(label: "xiaolachuxing.LaunchManager.asynchronousQueue")
    /// 延迟 执行 任务 数组
    private var delayLaunchTaskArray: [FJFLaunchTask] = []
    /// 主线程runloop观察者
    private var mainObserver: CFRunLoopObserver?
    // MARK: - Life
    init() {
        isLowMdapAssignPhoneVersion = FJFLaunchManager.isLowerPhoneDevice(self.lowPhoneVersionLimit)
    }
    
    // MARK: - Public
    
    // 更新 马达指定的低版本
    public func updateLowPhoneVersionLimit(_ lowPhoneVersionLimit: Int) {
        self.lowPhoneVersionLimit = lowPhoneVersionLimit
    }
    
    // 添加 主队列 任务
    public func addMainQueueTaskBlock(taskBlock: FJFLaunchTaskBlock?) {
        self.addTaskBlock(taskBlock, .mainQueue)
    }
    
    // 添加 异步执行 任务
    public func addAsynQueueTaskBlock(taskBlock: FJFLaunchTaskBlock?) {
        self.addTaskBlock(taskBlock, .asynQueue)
    }
    
    // 依据 任务 所属 类型 添加 任务
    public func addTaskBlock(_ taskBlock: FJFLaunchTaskBlock?, _ blongType: FJFLaunchTaskBlongType) {
        let task_item = DispatchWorkItem {
            taskBlock?()
        }
        switch(blongType) {
        case .mainQueue:
            task_item.perform()
        case .asynQueue:
            self.asyn_queue.async(execute: task_item)
        }
    }
    
    // 依据 手机版 判断 是否 需要延期任务
    public func checkTaskBlockNeedDelay(_ taskBlock: FJFLaunchTaskBlock?,
                                        _ blongType: FJFLaunchTaskBlongType,
                                        _ taskPriorityType: FJFLaunchTaskPriorityType = .defaultPriority) {
        if self.isLowMdapAssignPhoneVersion {
            self.addDelayTaskBlock(taskBlock, blongType, taskPriorityType)
        } else {
            self.addTaskBlock(taskBlock, blongType)
        }
    }
    
    // 依据 任务 所属 类型 添加 延迟执行 任务
    public func addDelayTaskBlock(_ taskBlock: FJFLaunchTaskBlock?,
                                  _ blongType: FJFLaunchTaskBlongType,
                                  _ taskPriorityType: FJFLaunchTaskPriorityType = .defaultPriority) {
        self.delayLaunchTaskArray.append(FJFLaunchTask.init(taskBlock, blongType, taskPriorityType))
        self.delayLaunchTaskArray = self.delayLaunchTaskArray.sorted(by: { (obj1: FJFLaunchTask, obj2: FJFLaunchTask) -> Bool in
            return obj1.taskPriorityType.rawValue > obj2.taskPriorityType.rawValue
        })
    }
    
    // 执行 延迟 任务
    public func execDelayTask() {
        self.startRunloopIdleMonitor()
    }
    
    /// 开启 主线程 runloop 空闲 监听
    public func startRunloopIdleMonitor() {
        //获取当前RunLoop
        let runLoop: CFRunLoop = CFRunLoopGetMain()
        //定义一个观察者
        let activities = CFRunLoopActivity.beforeWaiting.rawValue | CFRunLoopActivity.exit.rawValue

        mainObserver = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, activities, true, 0) { [weak self] (_, _) in
            guard let self = self else {
                return
            }
            
            if let tmpTask = self.delayLaunchTaskArray.first {
                self.addTaskBlock(tmpTask.taskBlock, tmpTask.taskBlongType)
                self.delayLaunchTaskArray.removeFirst()
            }
            
            if self.delayLaunchTaskArray.count == 0 {
                self.endRunloopIdleMonitor()
            }
        }
        
        if let tmpObserver = mainObserver {
            //添加当前RunLoop的观察者
            CFRunLoopAddObserver(runLoop, tmpObserver, .commonModes)
        }
    }
    
    /// 结束 runloop 空闲监听
    public func endRunloopIdleMonitor() {
        if let tmpObserver = mainObserver {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), tmpObserver, CFRunLoopMode.commonModes)
            mainObserver = nil
        }
    }
    // MARK: - Private
    // 低型号 手机 (iPhoneX及其以下)
    private class func isLowerPhoneDevice(_ lowPhoneVersionLimit: Int) -> Bool {
        let tipStr = "iPhone"
        var isLowMdapAssignDeviceVersion = false
        let deviceName = phoneDeviceName()
        if deviceName.contains(tipStr) {
            let array = deviceName.components(separatedBy: ",")
            if array.count == 2 {
                let phoneVersionName = (array.first ?? "") as NSString
                if phoneVersionName.length > tipStr.count {
                    let tipRange = NSRange(location: tipStr.count, length: phoneVersionName.length - tipStr.count)
                    let version = phoneVersionName.substring(with: tipRange)
                    let deviceVersion = Int(version) ?? 0
                    if deviceVersion < lowPhoneVersionLimit {
                        isLowMdapAssignDeviceVersion = true
                    }
                }
            }
        }
        return isLowMdapAssignDeviceVersion
    }
    
    /// 设备的名字
    private class func phoneDeviceName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
