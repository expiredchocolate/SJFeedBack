//
//  SJTextView.swift
//  SJFeedBack
//
//  Created by 过保的chocolate on 2017/6/19.
//  Copyright © 2017年 gsj. All rights reserved.
//
/// 显示带有站位文字的textView，并显示已输入文字的个数
import UIKit
import SnapKit
class SJTextView: UIView {

    /// 最大输入文字的长度
    public var maxStringLength: Int = 100
    /// textView的背景颜色
    public var textViewBgColor: UIColor = .white
    /// 站位文字的颜色
    public var placeHolderTextColor: UIColor = .gray
    
    public var placeHolderString: String = "请输入您的意见或反馈"
    /// 取得最后输入的文字
    public var text: String {
        get {
            return self.textView.text
        }
    }
    
    
    
    fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .black
        textView.delegate = self
        return textView
    }()
    fileprivate lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = self.placeHolderString
        label.textColor = self.placeHolderTextColor
        return label
    }()
    fileprivate lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = self.placeHolderTextColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    fileprivate func setupViews() {
        self.backgroundColor = .white
        addSubview(textView)
        textView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.bottom.equalToSuperview().offset(-25)
        }
        
        addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(7)
            maker.left.equalToSuperview().offset(15)
        }
        addSubview(countLabel)
        countLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(textView.snp.bottom).offset(3)
            maker.right.equalToSuperview().offset(-15)
        }
        self.countLabel.text = "\(textView.text.characters.count)/\(self.maxStringLength)字"
    }
    
}

extension SJTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count <= 0 {
            self.placeHolderLabel.isHidden = false
        } else {
            self.placeHolderLabel.isHidden = true
        }
        
        self.countLabel.text = "\(textView.text.characters.count)/\(self.maxStringLength)字"
        //超过最大字数
        if textView.text.characters.count >= self.maxStringLength {
    
            textView.text = textView.text[0..<self.maxStringLength-1]
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { //判断输入的字是否是回车，即按下return
            textView.endEditing(true)
            return false
        }
        return true
    }
}


