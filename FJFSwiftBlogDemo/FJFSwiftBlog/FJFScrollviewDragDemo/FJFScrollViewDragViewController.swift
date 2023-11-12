//
//  FJFScrollViewDragViewController.swift
//  FJFSwiftBlogDemo
//
//  Created by peakfang on 2023/7/18.
//

import UIKit

class FJFScrollViewDragViewController: UIViewController {
    // MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        self.view.addSubview(self.externalScrollView)
        self.externalScrollView.addSubview(self.insideHeaderView)
        self.externalScrollView.addSubview(self.insideTableView)
        self.externalScrollView.frame = self.view.bounds
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.scrollDragHelper.lowestShowHeight = kScreenH * 0.3
        self.scrollDragHelper.middleShowHeight = kScreenH * 0.52
        self.externalScrollView.frame = CGRect(x: 0, y: self.scrollDragHelper.getMiddlePositionToTopDistance(), width: self.view.width, height: kScreenH)
        self.insideHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 200)
        self.insideTableView.frame = CGRect(x: 0, y: self.insideHeaderView.frame.maxY, width: self.view.width, height: kScreenH - self.insideHeaderView.height)
        self.scrollDragHelper.addPanGestureRecognizer(externalScrollView: self.externalScrollView)
    }
    
    // MARK: - Delegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let shouldStop = self.scrollDragHelper.isNeedToStopScrollAndUpdateScrollType(scrollView: scrollView)
        if shouldStop {
            return
        }
    }
    
    /// 开始拖动
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollDragHelper.updateCurrentScrollTypeWhenBeginDragging(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollDragHelper.updateCurrentScrollTypeWhenScrollEnd(scrollView)
    }
    /// 用手滚动结束时重新添加定时器
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollDragHelper.updateCurrentScrollTypeWhenScrollEnd(scrollView)
    }

    private func gotoTheTopPosition(withAnimated animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.18, delay: 0, options: .allowUserInteraction) {
                self.externalScrollView.top = self.scrollDragHelper.getTopPositionToTopDistance()
            }
        } else {
            self.externalScrollView.top = self.scrollDragHelper.getTopPositionToTopDistance()
        }
    }

    private func gotoMiddlePosition(withAnimated animated: Bool = true) {
        self.insideTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if animated {
            UIView.animate(withDuration: 0.18, delay: 0, options: .allowUserInteraction) {
                self.externalScrollView.top = self.scrollDragHelper.getMiddlePositionToTopDistance()
            }
        } else {
            self.externalScrollView.top = self.scrollDragHelper.getMiddlePositionToTopDistance()
        }
    }
    
    private func gotoLowestPosition(withAnimated animated: Bool = true) {
        self.insideTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if animated {
            UIView.animate(withDuration: 0.18, delay: 0, options: .allowUserInteraction) {
                self.externalScrollView.top = self.scrollDragHelper.getBottomPositionToTopDistance()
            }
        } else {
            self.externalScrollView.top = self.scrollDragHelper.getBottomPositionToTopDistance()
        }
    }
    
    // MARK: - Lazy
    lazy var scrollDragHelper: FJFScrollDragHelper = {
        let tool = FJFScrollDragHelper()
        tool.topShowHeight = kScreenH - (kStatusBarFrameH + 20.0)
        tool.insideScrollView = self.insideTableView
        tool.goToTopPosiionBlock = { [weak self] in
            guard let self = self else { return }
            self.gotoTheTopPosition()
        }
        
        tool.goToMiddlePosiionBlock  = { [weak self] in
            guard let self = self else { return }
            self.gotoMiddlePosition()
        }
        
        tool.goToLowestPosiionBlock  = { [weak self] in
            guard let self = self else { return }
            self.gotoLowestPosition()
        }
        return tool
    }()
    
    /// 外层滚动视图
    lazy var externalScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .white
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    /// 头部view
    lazy var insideHeaderView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .red
        return view
    }()
    
    /// 内层滚动视图
    lazy var insideTableView: FJFContentTableView = {
        let view = FJFContentTableView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        view.delegate = self
        view.dataSource = self
        view.keyboardDismissMode = .onDrag
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0.0
        }
        return view
    }()
}

extension FJFScrollViewDragViewController: UITableViewDelegate {
    
    // 设置单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 100
    }
    
    // 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


extension FJFScrollViewDragViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
        }
        cell?.backgroundColor = UIColor(red: CGFloat (arc4random()%256)/255.0, green: CGFloat (arc4random()%256)/255.0, blue: CGFloat (arc4random()%256)/255.0, alpha: 1)
        cell?.textLabel?.textColor = .black
        return cell!
    }
}
