//
//  FJFImageTableViewCell.swift
//  FJFSwiftBlogDemo
//
//  Created by peakfang on 2023/2/25.
//

import UIKit
import SDWebImage

class FJFImageTableViewCell: UITableViewCell {
    public static var reuseID = "FJFImageTableViewCellId"

    public var imageCache: NSCache = NSCache<NSString, UIImage>()
    public var imageCacheDict: [String: UIImage] = [:]
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
    public func loadImageUrl(imageUrl: String) {

        if let tmpUrl = URL.init(string: imageUrl) {
            let imageString = imageUrl as NSString
            print("-------------------imageString:\(imageString)")
            let cacheImage = self.imageCache.object(forKey: imageUrl as NSString)
            if let tmpImage = cacheImage {
                self.adImageView.image = tmpImage
            } else {
                DispatchQueue.global(qos: .default).async {
                    let imageData = NSData.init(contentsOf: tmpUrl)
                    DispatchQueue.main.async {
                        let adImage = UIImage(data: imageData! as Data)
                        self.adImageView.image = adImage
                        self.imageCache.setObject(adImage!, forKey: imageUrl as NSString)
                        let cacheImage = self.imageCache.object(forKey: imageUrl as NSString)
                        print("\(String(describing: cacheImage))")
                    }
                }
            }

        }
        
//        self.adImageView.sd_setImage(with: URL(string: imageUrl))
    }
    // MARK: - Private
    private func setupViewControls() {
        self.contentView.addSubview(adImageView)
    }
    
    private func layoutViewControls() {
        self.adImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(5)
        }
    }
    
    // MARK: - Lazy
    /// 广告 图标
    lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}
