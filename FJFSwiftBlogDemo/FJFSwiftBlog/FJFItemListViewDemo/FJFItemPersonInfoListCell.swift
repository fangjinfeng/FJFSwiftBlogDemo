//
//  FJFItemPersonInfoCell.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/29.
//

import UIKit

class FJFItemPersonInfoListCell: UITableViewCell {
    // MARK: - Life
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewControls()
        layoutViewControls()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    class public func cellHeight(itemCount: Int) -> Double{
        return Double(itemCount) * FJFItemPersonInfoView.viewHeight()
    }
    
    // 配置 cell
    public func configCell(personInfoList: [FJFPersonInfoModel]) {
        itemListView.viewStyle.itemCount = personInfoList.count
        itemListView.updateViewControls()
        for (index, itemView) in itemListView.viewArray.enumerated() {
            if let tmpItemView = itemView as? FJFItemPersonInfoView {
                if index < personInfoList.count {
                    tmpItemView.configView(addressModel: personInfoList[index])
                    if index == (personInfoList.count - 1) {
                        tmpItemView.bottomLineView.isHidden = true
                    } else {
                        tmpItemView.bottomLineView.isHidden = false
                    }
                }
            }
        }
    }
    
    // MARK: - Private
    private func setupViewControls() {
        self.backgroundColor = .clear
        self.contentView.addSubview(self.itemListView);
    }

    private func layoutViewControls() {
        self.itemListView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - Lazy
    lazy var itemListView: FJFItemAutoListView = {
        let listView = FJFItemAutoListView.init()
        listView.viewStyle.itemHeight = FJFItemPersonInfoView.viewHeight()
        listView.itemViewClosure = { [weak self] (index) -> UIView in
            return  FJFItemPersonInfoView.init()
        }
        listView.layer.cornerRadius = 8
        listView.clipsToBounds = true
        listView.backgroundColor = .white
        return listView
    }()

}
