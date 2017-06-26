//
//  SelectImageView.swift
//  BMKP
//
//  Created by 过保的chocolate on 2017/2/21.
//  Copyright © 2017年 bmkp. All rights reserved.
//

import UIKit

enum ImagePickerVCType {
    case photoLibrary
    case camera
}
protocol SelectImageViewDelegate: class {
    func selecteImageViewdidFinish(_ selectImgaeView: SelectImageView, _ image: UIImage)
}

class SelectImageView: UIView {

    public typealias SelecteImgeDidComplete = ((SelectImageView,UIImage) -> Void)
    /// 宽高比
    var reshapeScale: CGFloat?
    var imagePickerType: ImagePickerVCType?
    var alert:UIAlertController?
    
    var selecteComplete: SelecteImgeDidComplete?
    
    weak var delegate: SelectImageViewDelegate?
    let photoMessage: String = "您拒绝了相册使用权限，请在手机设置 打开相册权限"
    let cameraMessage: String = "您拒绝了相机使用权限，请在手机设置 打开相机权限"
    /// 显示选择图片
    ///
    /// - Parameters:
    ///   - viewController: 填self
    ///   - reshapeScale:  宽高比
    func showSelectedImageActionSheet(on viewController: UIViewController,reshapeScale:CGFloat, selecteComplete: SelecteImgeDidComplete? = { _ in }) {
        
        self.reshapeScale = reshapeScale
        alert = UIAlertController.init(title: nil, message: "选择图片", preferredStyle: .actionSheet)
        let photoAction = UIAlertAction.init(title: "本地相册", style: .default) { (action) in
            
            // 获取用户的权限 询问用户要求权限
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePickerType = .photoLibrary
                let imagePicker = UIImagePickerController.init()
                imagePicker.sourceType = .photoLibrary
                // 下面的方法也可以实现裁剪，本次使用中自定义方法裁剪图片，可以裁剪自定义比例
                // imagePicker.allowsEditing = true
                imagePicker.delegate = self
                viewController.present(imagePicker, animated: true, completion: { })
            } else {
                UIAlertController.showAlert(add: viewController, title: "", message: self.photoMessage, cancelButton: "确定", othersButton: [],tapBlock: { (index) in })
            }
        }
        alert?.addAction(photoAction)
        let camaraAction: UIAlertAction = UIAlertAction.init(title: "拍摄照片", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerType = .camera
                let picker: UIImagePickerController = UIImagePickerController.init()
                picker.sourceType = .camera
                picker.delegate = self
                viewController.present(picker, animated: true, completion: { })
            } else {
                
                UIAlertController.showAlert(add: viewController, title: "", message: self.cameraMessage, cancelButton: "确定", othersButton: [],tapBlock: { (index) in })
            }
        }
        alert?.addAction(camaraAction)
        let cancleAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in }
        alert?.addAction(cancleAction)
        viewController.present(alert!, animated: true) { }
        self.selecteComplete = selecteComplete
    }
}

extension SelectImageView: UIImagePickerControllerDelegate {
    /// 点击取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    /// 选完图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        let VC = CutImageViewController()
        VC.sourceImage = image
        VC.reshapeScale = self.reshapeScale!
        VC.delegate = self
        picker.pushViewController(VC, animated: true)
        
    }
    
}

extension SelectImageView: UINavigationControllerDelegate {
    
}
extension SelectImageView: CutImageViewDelegate {
    
    func cutImageControllerDidCancel(_ cutImgaeView: CutImageViewController) {
        
        if imagePickerType == .camera {
            cutImgaeView.dismiss(animated: true, completion: nil)
            
        } else {
            let _ = cutImgaeView.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func cutImageControllerdidFinishPickingMedia(_ cutImgaeView: CutImageViewController, _ image: UIImage) {
        self.selecteComplete?(self,image)
        delegate?.selecteImageViewdidFinish(self, image)
        cutImgaeView.dismiss(animated: true) { 
            // 把状态栏设置回来
            UIApplication.shared.setStatusBarHidden(false, with: .slide)
            
        }
    }
}



protocol CutImageViewDelegate: class {
    /// 取消
    func cutImageControllerDidCancel(_ cutImgaeView: CutImageViewController)
    /// 选中
    func cutImageControllerdidFinishPickingMedia(_ cutImgaeView: CutImageViewController, _ image: UIImage)
    
}

/// 裁剪图片页面
class CutImageViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        return scrollView
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var frameView: UIImageView = {
        let frameView = UIImageView.init()
        // FIXME: 添加图片
        let image = UIImage.init(named: "icon_frame")
        let edge = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        image?.resizableImage(withCapInsets: edge, resizingMode: .stretch)
        frameView.image = image
        frameView.backgroundColor = .clear
        return frameView
    }()
    lazy var shapeView: ImageShapeView = {
        let shapeView = ImageShapeView()
        shapeView.backgroundColor = .clear
        shapeView.coverColor = UIColor.init(white: 0, alpha: 0.5)
        shapeView.isUserInteractionEnabled = false
        self.view.addSubview(shapeView)
        return shapeView
    }()
    lazy var selectButton: UIButton = {
        let selectButton = UIButton.init(type: .custom)
        selectButton.setTitle("使用", for: .normal)
        selectButton.setTitleColor(.white, for: .normal)
        selectButton.addTarget(self, action: #selector(selectedBtnCilck(sender:)), for: .touchUpInside)
        self.view.addSubview(selectButton)
        return selectButton
    }()
    lazy var cancelButton: UIButton = {

        let cancelButton = UIButton.init(type: .custom)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        return cancelButton
    }()
    lazy var shapeImage: UIImage = {
       
        let image: UIImage = self.imageView.image!
        return image.croppedImage(with: self.imageCropFrame)
    }()
    /// 最后裁剪时图片位置确定
    lazy var imageCropFrame: CGRect = {
        
        let imageSize: CGSize = self.imageView.image!.size
        let contentSize: CGSize = self.scrollView.contentSize
        let cropBoxFrame: CGRect = self.frameView.frame
        let contentOffset: CGPoint = self.scrollView.contentOffset
        let edgeInsets: UIEdgeInsets = self.scrollView.contentInset
        var frame: CGRect = .zero
        let a:CGFloat = contentOffset.x + edgeInsets.left
        let b:CGFloat = imageSize.width / contentSize.width
        frame.origin.x = floor(a * b)
        frame.origin.x = max(0, frame.origin.x)
        frame.origin.y = floor((contentOffset.y + edgeInsets.top) * (imageSize.height / contentSize.height))
        frame.origin.y = max(0, frame.origin.y)
        frame.size.width = ceil(cropBoxFrame.size.width * (imageSize.width / contentSize.width));
        frame.size.width = min(imageSize.width, frame.size.width);

        frame.size.height = ceil(cropBoxFrame.size.height * (imageSize.height / contentSize.height));
        frame.size.height = min(imageSize.height, frame.size.height);
        return frame;

    }()
    /// 源图片
    var sourceImage: UIImage?
    /// 宽高比
    var reshapeScale: CGFloat = 1
    weak var delegate: CutImageViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        layoutScrollView()
        self.shapeView.shapePath = UIBezierPath.init(rect: frameView.frame)
        self.shapeView.coverColor = UIColor.init(white: 0, alpha: 0.7)
        self.shapeView.setNeedsDisplay()
        // Do any additional setup after loading the view.
    }
    
    
    func setUpUI() {
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.frame = self.view.bounds
        view.addSubview(frameView)
        frameView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width/reshapeScale)
        frameView.center = self.view.center
        view.addSubview(shapeView)
        shapeView.frame = self.view.bounds
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(25)
            maker.bottom.equalToSuperview().offset(-25)
            maker.height.equalTo(25)
        }
        view.bringSubview(toFront: cancelButton)
        view.addSubview(selectButton)
        selectButton.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-25)
            maker.bottom.equalToSuperview().offset(-25)
            maker.height.equalTo(25)
        }
        view.bringSubview(toFront: selectButton)
        automaticallyAdjustsScrollViewInsets = false
    }
    
    func layoutScrollView() {
        imageView.image = self.sourceImage
        imageView.frame = CGRect(x:0, y:0,width: self.sourceImage!.size.width,height: self.sourceImage!.size.height)
        let imageSize: CGSize = self.sourceImage!.size
        scrollView.frame = self.view.bounds
        scrollView.contentSize = imageSize
        scrollView.addSubview(imageView)
        var scale: CGFloat = 0.0
        // 计算 图片适应屏幕的 size
        let cropBoxSize: CGSize = self.frameView.bounds.size
        //以cropboxsize 宽或者高最大的那个为基准
        scale = max(cropBoxSize.width/imageSize.width, cropBoxSize.height/imageSize.height);
        //按照比例算出初次展示的尺寸
        let scaledSize: CGSize = CGSize(width: floor(imageSize.width * scale), height: floor(imageSize.height * scale))
        //配置scrollview
        scrollView.minimumZoomScale = scale
        scrollView.maximumZoomScale = 5.0
        //初始缩放系数
        scrollView.zoomScale = self.scrollView.minimumZoomScale
        scrollView.contentSize = scaledSize
        let cropBoxFrame: CGRect = self.frameView.frame
        //调整位置 使其居中
        if cropBoxFrame.size.width < scaledSize.width - CGFloat(Float.ulpOfOne) || cropBoxFrame.size.height < scaledSize.height - CGFloat(Float.ulpOfOne) {
            var offset: CGPoint = .zero
            offset.x = -floor((self.scrollView.frame.width - scaledSize.width) * 0.5)
            offset.y = -floor((self.scrollView.frame.height - scaledSize.height) * 0.5)
            self.scrollView.contentOffset = offset;
        }
        // 以cropBoxFrame为基准设施 scrollview 的insets 使其与cropBoxFrame 匹配 防止 缩放时突变回顶部
        scrollView.contentInset = UIEdgeInsets(top: cropBoxFrame.minY, left: cropBoxFrame.minX, bottom: self.view.bounds.maxY - cropBoxFrame.maxY, right: self.view.bounds.maxX - cropBoxFrame.maxX)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    /// 点击取消
    func cancelBtnClick(sender: UIButton) {
        delegate?.cutImageControllerDidCancel(self)
    }
    /// 点击选择
    func selectedBtnCilck(sender: UIButton) {
        delegate?.cutImageControllerdidFinishPickingMedia(self, self.shapeImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension CutImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}


class ImageShapeView: UIView {
    
    var shapePath: UIBezierPath?
    lazy var shapePaths: [UIBezierPath] = []
    var coverColor: UIColor?

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.clear(rect)
        let clipPath: UIBezierPath = UIBezierPath.init(rect: self.bounds)
        if self.shapePath != nil {
            clipPath.append(self.shapePath!)
        }
        for path in self.shapePaths {
            clipPath.append(path)
        }
        clipPath.usesEvenOddFillRule = true
        clipPath.addClip()
        if self.coverColor == nil {
            self.coverColor = .black
            context.setAlpha(0.7)
        }
        self.coverColor?.setFill()
        clipPath.fill()
        
    }

}

