//
//  UIView+extension.swift
//  SJFeedBack
//
//  Created by 过保的chocolate on 2017/6/21.
//  Copyright © 2017年 gsj. All rights reserved.
//

import UIKit

extension UIView {
    /// 添加一个旋转的菊花
    func addActivity(style: UIActivityIndicatorViewStyle, size: CGSize) {
        let maskView: UIView = UIView(frame: self.bounds)
        maskView.tag = 100020
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubview(maskView)
        self.isUserInteractionEnabled = false
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: style)
        let activityW: CGFloat = size.width
        let activityH: CGFloat = size.height
        let activityX: CGFloat = (maskView.frame.size.width - activityW) / 2
        let activityY: CGFloat = (maskView.frame.size.width - activityH) / 2
        activityIndicator.frame = CGRect(x: activityX, y: activityY, width: activityW, height: activityH)
        activityIndicator.color = .white
        maskView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    /// 移除菊花
    func removeActivity() {
        
        guard let activity: UIView = self.viewWithTag(100020) else { return }
        activity.removeFromSuperview()
        self.isUserInteractionEnabled = true
        
    }
    
}
