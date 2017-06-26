//
//  UIAlertController+extension.swift
//  SJFeedBack
//
//  Created by 过保的chocolate on 2017/6/25.
//  Copyright © 2017年 gsj. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func showAlert(add: UIViewController? , title: String , message: String ,cancelButton: String? = "取消" , othersButton:[String]? ,tapBlock: @escaping (_ index: Int) -> Void = { _ in }) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelButton, style: .cancel, handler: {
            action in
            tapBlock(0)
            
        })
        alertController.addAction(cancelAction)
        
        if let othersButton = othersButton {
            
            for buttonTitle in othersButton {
                
                let action = UIAlertAction(title: buttonTitle, style: .default, handler: {
                    action in
                    let aa: String = action.title!
                    let bb: [String] = othersButton
                    let atIndex: Int = bb.index(of: aa)!
                    tapBlock(atIndex + 1)
                    
                })
                alertController.addAction(action)
                
            }
        }
        
        add?.present(alertController, animated: true, completion: nil)
        
    }

    
}
