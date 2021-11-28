//
//  FJFItemPersonInfoView.swift
//  FJFTestBlogDemo
//
//  Created by peakfang on 2021/10/29.
//

import UIKit

class FJFItemPersonInfoView: UIView {

    // MARK: - Life
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewControls()
        layoutViewControls()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public
    class public func viewHeight() -> Double {
        return 65.0
    }
    

    // 配置view
    public func configView(addressModel: FJFPersonInfoModel) {
        self.nameLabel.text = addressModel.name ?? ""
        self.sexLabel.text = addressModel.sex ?? ""
        self.addressNameLabel.text = addressModel.cityName ?? ""
        self.addressDetailLabel.text = addressModel.address ?? ""
    }
    
    
    // MARK: - Private
    private func setupViewControls() {
        self.addSubview(self.nameLabel)
        self.addSubview(self.sexLabel)
        self.addSubview(self.addressNameLabel)
        self.addSubview(self.addressDetailLabel)
        self.addSubview(self.bottomLineView)
    }
    
    
    private func layoutViewControls() {
        // 图标
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(120)
        }
        
        // 更多操作
        self.sexLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview();
            make.trailing.equalToSuperview().offset(-12);
        }
        
        // 地址名称
        self.addressNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.nameLabel)
            make.trailing.equalTo(self.sexLabel.snp.leading).offset(-12)
            make.leading.equalTo(self.nameLabel.snp.trailing).offset(10)
        }
        
        // 详细地址
        self.addressDetailLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.nameLabel)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(2);
            make.trailing.equalTo(self.addressNameLabel)
        }
        
        // 分割线
        self.bottomLineView.snp.makeConstraints { make in
            make.leading.equalTo(self.nameLabel)
            make.bottom.equalTo(self);
            make.height.equalTo(1)
            make.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Lazy
    
    // 名称
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        return lbl
    }()
    
    // 性别
    lazy var sexLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textColor = .black
        lbl.textAlignment = .right
        lbl.numberOfLines = 1
        return lbl
    }()
    
    // 地址名称
    lazy var addressNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        return lbl
    }()
    
    // 详细 地址 名称
    lazy var addressDetailLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        return lbl
    }()

    // 分割线
    lazy var bottomLineView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 1
        view.layer.masksToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()

}
