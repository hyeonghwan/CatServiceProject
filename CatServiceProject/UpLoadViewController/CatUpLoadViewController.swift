//
//  CatUpLoadViewController.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/15.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class CatUploadViewController: UIViewController{
    
    private var catService: CatServiceProtocol?
    private var url: String?
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    private lazy var imageplaceholder: UILabel = {
       let label = UILabel()
        label.text = "이미지를 업로드해 주세요!"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private lazy var upLoadButton: AnimationButton = {
       let button = AnimationButton()
        button.backgroundColor = .systemCyan
        let title = NSAttributedString(string: "업로드",
                                       attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,
                                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)])
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(upLoadButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.catService = CatService2()
    }
    
}
extension CatUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.imageURL] as? URL else {print("nil"); return}
        print(image)
        guard let mediaType = info[.mediaType] as? NSString else {return}
        print("mediaTypeL \(mediaType)")
        
        self.imageView.kf.setImage(with: image)
   }
}

private extension CatUploadViewController{
    
    func configure() {
        self.view.backgroundColor = .systemCyan
        self.navigationItem.title = "업로드"
        let addButton =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
        addButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = addButton
        
        self.view.addSubview(imageContainerView)
        
        imageContainerView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(200)
            $0.width.height.equalTo(300)
        }
        imageContainerView.addSubview(self.imageplaceholder)
        
        imageplaceholder.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
        imageContainerView.addSubview(self.imageView)
        imageView.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        self.view.addSubview(self.buttonContainerView)
        buttonContainerView.snp.makeConstraints{
            $0.top.equalTo(imageContainerView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(50)
        }
        self.buttonContainerView.addSubview(self.upLoadButton)
        upLoadButton.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func addPicture() {
        print("addPicture")
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        present(imagePickerVC, animated: true)
        imagePickerVC.delegate = self // new
        present(imagePickerVC, animated: true)
    }
    
    @objc func upLoadButtonTapped(_ sender: UIButton){
        if let image = self.imageView.image {
            
//            self.catService?.upLoadImage(image, completion: nil)
        }
    }
    
}
