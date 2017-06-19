//
//  SJFeedBackViewController.swift
//  SJFeedBack
//
//  Created by 过保的chocolate on 2017/6/19.
//  Copyright © 2017年 gsj. All rights reserved.
//

import UIKit

class SJFeedBackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }

    func setupViews() {
        title = "意见反馈"
        view.backgroundColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
