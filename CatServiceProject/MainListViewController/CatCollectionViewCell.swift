//
//  CatCollectionViewCell.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/04.
//

import UIKit
import Kingfisher
import SnapKit

final class CatCollectionViewCell: UICollectionViewCell {
    
    private var favoriteAddFlag: Bool?
    private var indexPath: IndexPath?
    private var favoriteFlagDelegate: FavoriteFlagDataSendDelegate?
    private var image_id: String?
    private var image_URL: String?
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    lazy var hStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        
        return stackView
    }()
    lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.text = "Like 0"
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .black
        return label
    }()
    
    let heartImage = UIImage(systemName: "heart",
                             withConfiguration: UIImage.SymbolConfiguration(
                                 pointSize: 25,
                                 weight: UIImage.SymbolWeight.light ,
                                 scale: .large))
    let heartFillImage = UIImage(systemName: "heart.fill",
                                 withConfiguration: UIImage.SymbolConfiguration(
                                     pointSize: 25,
                                     weight: UIImage.SymbolWeight.light ,
                                     scale: .large))
    let starImage = UIImage(systemName: "star",
                            withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 25,
                                weight: UIImage.SymbolWeight.light ,
                                scale: .large))
    let starFillImage = UIImage(systemName: "star.fill",
                            withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 25,
                                weight: UIImage.SymbolWeight.light ,
                                scale: .large))
    
    lazy var heartButton: AnimationButton = {
        let btn = AnimationButton( primaryAction: UIAction(handler: { [unowned self] _ in
         
        }))
        btn.setImage(heartImage, for: .normal)
        btn.layer.masksToBounds = true
        btn.tintColor = .black
        return btn
    }()
    
    lazy var favoriteAddButton: AnimationButton = {
        let button = AnimationButton( primaryAction: UIAction(handler: { [unowned self] _ in
            
        }))
        button.setImage(starImage, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        print("Cat collectionViewCell override init called")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Cell UpdateUI
    /// - Parameter catsCellViewModel: catMainViewModel이 가지고 있는 데이터
    /// - Parameter indexPath: collectionView 의 IndexPath 위치값
    /// - Parameter delegate: CatMainListViewController를 받아와서 데이터 전달
    func updateUI(_ catsCellViewModel: CatCellModel,_ indexPath: IndexPath, _ delegate: FavoriteFlagDataSendDelegate) {
        guard let url = catsCellViewModel.imageURL else {print("cell ImageURL ERROR"); return}
        guard let favoriteFlag = catsCellViewModel.favoriteFlag else {print("favoriteflag ERROR"); return}
        guard let id = catsCellViewModel.id else {print("id error"); return}
        self.image_URL = url
        self.favoriteFlagDelegate = delegate
        self.imageView.kf.setImage(with: URL(string: url))
        self.favoriteAddFlag = favoriteFlag
        self.image_id = id
        self.indexPath = indexPath

        if self.favoriteAddFlag! {

            self.favoriteAddButton.setImage(starFillImage, for: .normal)
            self.heartButton.setImage(heartFillImage, for: .normal)
        }else{
            self.favoriteAddButton.setImage(starImage, for: .normal)
            self.heartButton.setImage(heartImage, for: .normal)
        }
        
        
    }
    
    
}

private extension CatCollectionViewCell {
 
    
    /// cell 설정 , 오토레이아웃
    func configure() {
        self.contentView.layer.borderWidth = 1
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(heartButton)
        self.contentView.addSubview(likeLabel)
        self.contentView.addSubview(favoriteAddButton)
        let index = Int(UIScreen.main.bounds.height / 3 )
        imageView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            
            $0.height.equalTo(index)
        }
        heartButton.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        likeLabel.snp.makeConstraints{
            $0.centerY.equalTo(heartButton.snp.centerY)
            $0.centerX.equalToSuperview()
        }
        favoriteAddButton.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        favoriteAddButton.onCompleted = { [weak self] isHighlighedFlag in
            
            guard let self = self else {print("self failed "); return}
            
            if isHighlighedFlag == false{
                
                self.favoriteAddFlag?.toggle()
                self.favoriteFlagDelegate?.favoriteToggle(self.favoriteAddFlag ?? false, self.indexPath ?? IndexPath(), self.image_URL ?? "",  self.image_id ?? "")
                
            }
            
            
          
        }
      
    }
    
}
