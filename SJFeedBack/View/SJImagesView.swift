 //
//  SJImagesView.swift
//  SJFeedBack
//
//  Created by 过保的chocolate on 2017/6/20.
//  Copyright © 2017年 gsj. All rights reserved.
//
/// 图片上传选择
import UIKit
import SnapKit
class SJImagesView: UIView {

    public var messageLabelString: String = "请提供相关照片或截图"
    /// 需要上传的图片的数量
    public var needImageNum: Int = 2
    
    public var maxPhotoCount: Int = 2
    
    public var photoSelecteBtnBlock: ((PhotoButton) -> Void)?
    
    fileprivate var didLayoutSubview: Bool = false
    
    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = self.messageLabelString
        label.textColor = .black
        return label
    }()
    
    
    fileprivate lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        return label
        
    }()

    /// 计算已经选中的图片的个数
    @discardableResult
    fileprivate func calculatePhotoCount() -> Int  {
        var photoCount: Int = 0
        for view in self.subviews {
            if let photoBtn =  view as? PhotoButton {
                if photoBtn.status == .loaded {
                    photoCount += 1
                }
            }
        }
        countLabel.text = "\(photoCount)/\(maxPhotoCount)"
        return photoCount
    }
    
    fileprivate func setupButton() -> PhotoButton {
        let button = PhotoButton()
        return button
    }
    
    
    
    override func layoutSubviews() {
        if didLayoutSubview { return }
        super.layoutSubviews()
        setupViews()
        
    }
    
    

}

extension SJImagesView {
    
    fileprivate func setupViews() {
        backgroundColor = .white
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(10)
            maker.left.equalToSuperview().offset(8)
        }
        addSubview(countLabel)
        countLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(messageLabel.snp.centerY)
            maker.right.equalToSuperview().offset(-8)
        }

        setupPhotoButtons()
        didLayoutSubview = true
    }
    
    /// 减少button
    public func reducePhotoButton() {
        // FIXME: 有个bug 不按顺序删除，就会有问题，记得改
        var array: [PhotoButton] = []
        for view in self.subviews {
            if let photoBtn =  view as? PhotoButton{
                array.append(photoBtn)
            }
        }
        var loadedArray: [PhotoButton] = []
        for view in self.subviews {
            if let photoBtn =  view as? PhotoButton {
                if photoBtn.status == .loaded {
                    loadedArray.append(photoBtn)
                }
            }
        }
        if array.count <= 1 || (array.count == self.maxPhotoCount && loadedArray.count == self.maxPhotoCount) { return }
        array.last?.removeFromSuperview()
    }
    
    public func setupPhotoButtons() {
        /// 如果超过或等于最大上传图片数，则不添加空的photoButton
        if calculatePhotoCount() >= maxPhotoCount { return }
        let button = setupButton()
        addSubview(button)
        
        var array: [PhotoButton] = []
        for view in self.subviews {
            if let photoBtn =  view as? PhotoButton {
                if photoBtn.status == .loaded {
                    array.append(photoBtn)
                }
            }
        }

        if let lastButton = array.last {
            button.snp.makeConstraints({ (maker) in
                maker.top.equalTo(lastButton.snp.top)
                maker.left.equalTo(lastButton.snp.right).offset(5)
                maker.width.height.equalTo(100)
            })
            
        } else {
            button.snp.makeConstraints { (maker) in
                maker.top.equalTo(messageLabel.snp.bottom).offset(5)
                maker.left.equalTo(messageLabel.snp.left)
                maker.width.height.equalTo(100)
            }
        }
        button.selectePhotoBlock = { [weak self] (sender) in
            self?.photoSelecteBtnBlock?(sender)
        }
        button.canccelPhotoBlock = { [weak self] (sender) in
            self?.reducePhotoButton()
            sender.status = .normal
            self?.calculatePhotoCount()
        }
        calculatePhotoCount()
    }

}


