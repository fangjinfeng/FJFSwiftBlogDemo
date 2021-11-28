//
//  FJFItemListViewController.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/14.
//

import UIKit
import SnapKit

class FJFItemListViewController: UIViewController {

    var personInfoList: [FJFPersonInfoModel] = [FJFPersonInfoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setupViewControls()
        self.layoutViewControls()
    }
    
    // MARK: - Private
    private func setupViewControls() {
        self.title = "itemListView"
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        self.personInfoList = FJFPersonListModel.defaultData()
    }
    
    private func layoutViewControls() {
        // 列表
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Lazy
    private lazy var tableView: UITableView = {
        let tableV = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableV.isScrollEnabled = false
        tableV.backgroundColor = .lightGray
        tableV.keyboardDismissMode = .onDrag
        tableV.separatorStyle = .none
        tableV.register(FJFItemPersonInfoListCell.self, forCellReuseIdentifier: NSStringFromClass(FJFItemPersonInfoListCell.self) as String)
        tableV.delegate = self
        tableV.dataSource = self
        return tableV
    }()
}

extension FJFItemListViewController: UITableViewDelegate {

    // 设置单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return FJFItemPersonInfoListCell.cellHeight(itemCount: personInfoList.count)
    }

    // 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

    }
}

extension FJFItemListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 常用 地址
        let identifierText: String = NSStringFromClass(FJFItemPersonInfoListCell.self)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifierText)

        if cell == nil {
            cell = FJFItemPersonInfoListCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifierText)
        }

        guard let cell = cell as? FJFItemPersonInfoListCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configCell(personInfoList: personInfoList)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: .zero)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 12))
        view.backgroundColor = .clear
        return view
    }
}
