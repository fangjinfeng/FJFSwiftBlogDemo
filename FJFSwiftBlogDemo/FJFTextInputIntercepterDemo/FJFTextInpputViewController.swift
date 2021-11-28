//
//  FJFTextInpputViewController.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/20.
//

import UIKit

class FJFTextInpputViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "输入框拦截器"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    

    // MARK: - Lazy
    lazy var viewDataArray: [String] = [
                                        "修改个人简介",
                                        "修改个人信息"
                                        ]
    
    lazy var tableView: UITableView = {
        let tableV = UITableView.init(frame: CGRect.zero, style: .plain)
        tableV.isScrollEnabled = false
        tableV.backgroundColor = .white
        tableV.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.01))
        tableV.keyboardDismissMode = .onDrag
        tableV.backgroundColor = UIColor.white
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        tableV.delegate = self
        tableV.dataSource = self
        return tableV
    }()
}

extension FJFTextInpputViewController: UITableViewDelegate {
    
    // 设置单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 100
    }
    
    // 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 0 {
            let vc = FJFPersonalDescEditViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension FJFTextInpputViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = NSStringFromClass(UITableViewCell.self)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
        }
        
        guard let cell = cell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = viewDataArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}
