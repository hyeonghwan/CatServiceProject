//
//  CustomSegmentedControl.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/06.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

 class CustomSegmentControl: UIView{
    
    private var buttonTitles: [String]!
    private var buttonArray: [CatBreedsButton] = []
     private let viewModel = CatBreedsViewModel()
     private var viewModelButton : [CatBreedsButton] = []
     
     private var image: UIImage = {
        let image = UIImage(systemName: "circle")
         return image ?? UIImage()
     }()
     var imageView: UIImageView = {
         let img = UIImageView()
         img.contentMode = .scaleAspectFill
         img.clipsToBounds = true
         return img
     }()
    var textColor: UIColor = .white
    var selectorViewColor: UIColor = .black
    var selectorTextColor: UIColor = .black
     
     private lazy var scrollView: UIScrollView = {
         let scrollView = UIScrollView()
         scrollView.showsHorizontalScrollIndicator = false
         return scrollView
     }()
     
    private func configStackView() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        scrollView.addSubview(stack)
        
        buttonArray.forEach{
            stack.addArrangedSubview($0)
        }
        stack.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
    }
     private func getImage() {
         viewModel.getCatListHeaderImage{ imageArr in
             var count = 0
                     DispatchQueue.main.async { [weak self] in
                         guard let self = self else {return}
                         self.buttonArray.forEach{
                             $0.setImage(imageArr[count], for: .normal)
                             count += 1
                         }
                     }
         }
     }
     func getButtons() {
         var buttons: [CatBreedsButton] = []
         (0...10).forEach {  value in
             let button = CatBreedsButton()
             button.addTarget(self,
                              action: #selector(ButtonTabAction(sender:)),
                              for: .touchUpInside)
             button.snp.makeConstraints{
                 $0.width.equalTo(50)
                 $0.height.equalTo(50)
             }
             buttons.append(button)
         }
         self.buttonArray = buttons
     }
     
     @objc func ButtonTabAction(sender: UIButton){
         debugPrint("\(sender.titleLabel?.text)")
     }

     private func addContent() {
         self.addSubview(scrollView)
     }
     
     private func addAutoLayout() {
         scrollView.snp.makeConstraints{
             $0.leading.equalToSuperview()
             $0.top.trailing.bottom.equalToSuperview()
         }
     }
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         getImage()
         getButtons()
         addContent()
         addAutoLayout()
         configStackView()
         
     }
    
    convenience init(frame: CGRect, buttonTitle: [String]) {
        self.init(frame: frame)
        debugPrint("convenience init called")
        
        
    }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     override func draw(_ rect: CGRect) {
        super.draw(rect)
        debugPrint("draw Rect Called")
        
        
    }
    func setButtonTitles(buttonTitles: [String]){
        
        debugPrint("setButtonTitles called")
        
    }
    
}
