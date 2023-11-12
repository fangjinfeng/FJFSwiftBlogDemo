//
//  FJFTableReloadViewController.swift
//  
//
//  Created by peakfang on 2023/2/24.
//

import UIKit

public class FJFTableReloadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    public var picList: [String] = [
        "https://upload-images.jianshu.io/upload_images/2252551-c4deb97c7b183f19.png",
        "https://upload-images.jianshu.io/upload_images/17879190-b722e7e6cd7837e0.jpg",
        "https://upload-images.jianshu.io/upload_images/2252551-1acb5713cbdf93d3.jpeg",
        "http://gss0.baidu.com/-fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/aec379310a55b31905caba3b43a98226cffc1748.jpg",
            ]
    // MARK: - Life
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControls()
        layoutViewControls()
        setupNetworkRequest()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.contentTableView.reloadData()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Public
    
    // MARK: - Noti
    
    // MARK: - Delegate
    // 设置单元格高度
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 100
    }
    
    // 点击cell
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            print("-------------------------调用self.contentTableView.reloadData")
            self.contentTableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.picList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indentifier = FJFImageTableViewCell.reuseID
        var cell = tableView.dequeueReusableCell(withIdentifier: indentifier)
        
        if cell == nil {
            cell = FJFImageTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: indentifier)
        }
        
        guard let cell = cell as? FJFImageTableViewCell else {
            return UITableViewCell()
        }
        cell.loadImageUrl(imageUrl: self.picList[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        print("-------------------------indexPath:\(indexPath) cell:\(cell)")
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.size.width, height: 12))
        view.backgroundColor = .lightGray
        return view
    }
    
    // MARK: - Response
    
    // MARK: - Private
    
    /// 初始化视图
    private func setupViewControls() {
        self.view.addSubview(self.contentTableView)
    }
    /// 布局 视图
    private func layoutViewControls() {
        self.contentTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    /// 设置 网络 请求
    private func setupNetworkRequest() {
        
    }
    
    // MARK: - Lazy
    lazy var contentTableView: UITableView = {
        let tableV = UITableView.init(frame: CGRect.zero, style: .plain)
        tableV.register(FJFImageTableViewCell.self, forCellReuseIdentifier: FJFImageTableViewCell.reuseID)
        tableV.separatorStyle = .none
        tableV.backgroundColor = UIColor.white
        tableV.delegate = self
        tableV.dataSource = self
        return tableV
    }()
}

