//
//  FJFContentTableView.swift
//  FJFSwiftBlogDemo
//
//  Created by peakfang on 2023/7/18.
//

import UIKit

class FJFContentTableView: UITableView {

}

extension FJFContentTableView: UIGestureRecognizerDelegate {
    /// 保证可以响应多种手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view is UICollectionView {
            return false
        }
        return true
    }
}
