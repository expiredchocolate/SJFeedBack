//
//  PhotoButton.swift
//  SJFeedBack
//
//  Created by 过保的chocolate on 2017/6/25.
//  Copyright © 2017年 gsj. All rights reserved.
//

import UIKit

/// 显示图片的按钮
enum PhotoButtonStatus {
    case normal
    case loading
    case loaded
}

class PhotoButton: UIView {
    
    public var status: PhotoButtonStatus = .normal{
        didSet {
            switch status {
            case .normal:
                self.imageView.image = UIImage.init(named: "set_feedback_phone")
                self.button.isUserInteractionEnabled = true
                self.cancelButton.isHidden = true
            case .loading:
                self.imageView.addActivity(style: .white, size: self.imageView.frame.size)
            case .loaded:
                self.imageView.removeActivity()
                self.button.isUserInteractionEnabled = false
                self.cancelButton.isHidden = false
                
            }
        }
        
    }
    public var selectePhotoBlock: ((PhotoButton) -> Void)?
    public var canccelPhotoBlock: ((PhotoButton) -> Void)?
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        return image
    }()
    /// 响应选择图片的按钮
    fileprivate lazy var button: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        return btn
    }()
    /// 关闭按钮
    fileprivate lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage.init(named: "set_feedback_cancel"), for: .normal)
        return btn
    }()
    
    fileprivate let space: Double = 10
    
    func selectePhotoBtnClick(sender: UIButton) {
        selectePhotoBlock?(self)
    }
    
    func cancelBtnClick(sender: UIButton) {
        canccelPhotoBlock?(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
}

extension PhotoButton {
    
    fileprivate func setupViews() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(space)
            maker.left.equalToSuperview().offset(space)
            maker.right.equalToSuperview().offset(-space)
            maker.bottom.equalToSuperview().offset(-space)
        }
        addSubview(button)
        button.addTarget(self, action: #selector(selectePhotoBtnClick(sender:)), for: .touchUpInside)
        button.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        cancelButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(imageView.snp.right)
            maker.centerY.equalTo(imageView.snp.top)
            maker.width.height.equalTo(20)
        }
        self.status = .normal
        
    }
    
}


