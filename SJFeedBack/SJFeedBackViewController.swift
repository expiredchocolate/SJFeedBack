//
//  SJFeedBackViewController.swift
//  SJFeedBack
//
//  Created by 过保的chocolate on 2017/6/19.
//  Copyright © 2017年 gsj. All rights reserved.
//

import UIKit

class SJFeedBackViewController: UIViewController {

    
    
    lazy var textView: SJTextView = {
        let textview = SJTextView()
        textview.maxStringLength = 200
        return textview
    }()
    
    lazy var imageView: SJImagesView = {
        let view = SJImagesView()
        view.maxPhotoCount = 3
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }

    func setupViews() {
        title = "意见反馈"
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        /// textView 光标出现在中间的位置则写下面一行代码可以解决
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(textView)
        textView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(94)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(170)
        }
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(textView.snp.bottom).offset(10)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(140)
        }
        
        imageView.photoSelecteBtnBlock = { (photoBtn) in
            let pickImageView: SelectImageView = SelectImageView()
            /// 弹出选择图片按钮
            pickImageView.showSelectedImageActionSheet(on: self, reshapeScale: 1, selecteComplete: { [weak self](selectImageView, image) in
                photoBtn.imageView.image = image
                photoBtn.status = .loaded
                self?.imageView.setupPhotoButtons()
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


