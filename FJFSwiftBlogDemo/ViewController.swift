//
//  ViewController.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/14.
//

import UIKit

class ViewController: UIViewController {

    public var sourceTimer: DispatchSourceTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "列表"
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Private
    func stringClassObjectFromString(className: String) -> UIViewController! {
        
        /// 获取命名空间
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
        
        /// 根据命名空间传来的字符串先转换成anyClass
        let cls: AnyClass = NSClassFromString(namespace + "." + className)!;
        
        // 在这里已经可以return了   返回类型:AnyClass!
        //return cls;
        
        /// 转换成 明确的类
        let vcClass = cls as! UIViewController.Type;
        
        /// 返回这个类的对象
        return vcClass.init();
    }
    
    // MARK: - Lazy
    lazy var tableView: UITableView = {
        let tableV = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), style: .plain)
        tableV.isScrollEnabled = false
        tableV.backgroundColor = UIColor.gray
        tableV.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.01))
        tableV.keyboardDismissMode = .onDrag
        tableV.backgroundColor = UIColor.white
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        tableV.delegate = self
        tableV.dataSource = self
        return tableV
    }()
    
   lazy var viewControllerDict: [String: String] = [
                                        "FJFImageLabelViewController": "imageLabelView",
                                        "FJFItemListViewController": "item列表view",
                                        "FJFTextInpputViewController": "输入框拦截器",
                                        "FJFLottieViewController": "lottie动画",
                                        "FJFButtonClickedViewController": "按键点击",
                                        "FJFTableReloadViewController": "tableView 刷新 闪烁",
                                        "FJFScrollViewDragViewController": "scrollView 拖动",
                                    ]
    
}

extension ViewController: UITableViewDelegate {
    
    // 设置单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 100
    }
    
    // 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)

        let keyArray = [String](viewControllerDict.keys)
        let keyStr = keyArray[indexPath.row]
        navigationController?.pushViewController(stringClassObjectFromString(className: keyStr), animated: true)
    }
}


extension ViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllerDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
        }
        
        let keyArray = [String](viewControllerDict.keys)
        let keyStr = keyArray[indexPath.row];
        let titleValue = viewControllerDict[keyStr]
        //使用字典的值作为标题 取字典 Value
        cell?.textLabel?.text = titleValue
        return cell!
    }

}
