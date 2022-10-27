//
//  CategoryArrayView.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/25.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

struct CategoryButtonAndLabel {
    let categoryButton: CategoryRoundedButton
    let categoryLabel: CategoryLabel
}

class CategoryArrayView: UIView{
    
    var categories: [RequestType] = [.breedType("abys", "Abyssinian", "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"),
                                     .breedType("aege", "Aegean", "https://cdn2.thecatapi.com/images/ozEvzdVM-.jpg"),
                                     .breedType("abob", "American Bobtail", "https://cdn2.thecatapi.com/images/hBXicehMA.jpg"),
                                     .breedType("acur", "American Curl", "https://cdn2.thecatapi.com/images/xnsqonbjW.jpg"),
                                     .breedType("asho", "American Shorthair", "https://cdn2.thecatapi.com/images/JFPROfGtQ.jpg"),
                                     .breedType("awir", "American Wirehair", "https://cdn2.thecatapi.com/images/8D--jCd21.jpg"),
                                     .breedType("amau", "Arabian Mau", "https://cdn2.thecatapi.com/images/k71ULYfRr.jpg"),]

    
    private lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var hStackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var categoryButtonItems: [CategoryButtonAndLabel] = {
        let frame: CGRect = .zero
    
        
        var items: [CategoryButtonAndLabel] = []
        
        categories.forEach{ requestType in
            
            let button = CategoryRoundedButton(frame: .zero, requestType: requestType)
            
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            items.append(CategoryButtonAndLabel(categoryButton: button,
                                                categoryLabel: CategoryLabel(frame: .zero, requestType: requestType)))
        }
        
        items.first?.categoryButton.isSelected = true
        items.first?.categoryLabel.buttonfocused = true
        
        return items
    }()
    
    @objc func buttonTapped(_ sender: CategoryRoundedButton){
        print("tapped")
        
        if sender.isSelected == false {
            categoryButtonItems
                .forEach{data in
                    data.categoryButton.isSelected = false
                    data.categoryLabel.buttonfocused = false
                }
            
            sender.isSelected = true
            
            self.categoryButtonItems.forEach{ buttonlabel in
                if buttonlabel.categoryButton.isSelected == true{
                    print("change")
                    buttonlabel.categoryLabel.buttonfocused = true
                }
            }
            
//            onChangeRequestType(sender.getButtonType())
        }
        
    }
    
    override init(frame: CGRect) {
        
//        let changingType = PublishSubject<RequestType>()
//
//        onChangeRequestType = {type in changingType.onNext(type)  }
//
//        onChanged = changingType
        
        super.init(frame: frame)
        configure()
    }
    convenience init(frame: CGRect ,_ requestTypes: [RequestType]){
        self.init(frame: frame)
        self.categories = requestTypes
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        scrollView.addSubview(hStackViewContainer)
        
        
        hStackViewContainer.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        for item in categoryButtonItems{
            
            let verticalStackView = UIStackView()
            
            verticalStackView.axis = .vertical
            verticalStackView.spacing = 10
            verticalStackView.alignment = .center
            verticalStackView.distribution = .equalSpacing
            
            hStackViewContainer.addArrangedSubview(verticalStackView)
            [item.categoryButton,item.categoryLabel].forEach{
                verticalStackView.addArrangedSubview($0)
            }
            
            item.categoryButton.snp.makeConstraints{
                $0.width.height.equalTo(60)
            }
            
            item.categoryLabel.snp.makeConstraints{
                $0.width.equalTo(80)
            }
        }
    }
}
