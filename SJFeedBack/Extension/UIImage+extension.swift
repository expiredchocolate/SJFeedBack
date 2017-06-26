//
//  UIImage.swift
//  SJFeedBack
//
//  Created by 过保的chocolate on 2017/6/25.
//  Copyright © 2017年 gsj. All rights reserved.
//

import UIKit

extension UIImage {
    /// 裁剪
    ///
    /// - Parameter frame: <#frame description#>
    func croppedImage(with frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, true, self.scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: -frame.origin.x, y: -frame.origin.y)
        self.draw(at: .zero)
        let croppedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return UIImage.init(cgImage: croppedImage.cgImage!, scale: UIScreen.main.scale, orientation: .up)
    }
}
