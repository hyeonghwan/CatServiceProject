//
//  CategoryArrayView.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/25.
//

import UIKit
import SnapKit
import RxSwift


class CategoryArrayView: UIView{
    
    var onChangeBreed: Observable<BreedType>
    
    private var onChangeBreedTypeCompletion: (BreedType) -> ()
    
    private var categories: [BreedType] = CategoryButtonAndLabel.dummyData()

    
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
    
    
    //Category Segments Items
    private lazy var categoryButtonItems: [CategoryButtonAndLabel] = {
        let frame: CGRect = .zero
        
        var items: [CategoryButtonAndLabel] = []
        
        categories.forEach{ requestType in
            
            let button = CategoryRoundedButton(frame: .zero, requestType: requestType)
            
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            items.append(CategoryButtonAndLabel(breedType: requestType,
                                                categoryButton: button,
                                                categoryLabel: CategoryLabel(frame: .zero, requestType: requestType)))
        }
        
        //first 버튼 Label select &  GET call Breed Image by onChangeBreedTypeCompletion
        if let item = items.first {
            item.categoryButton.isSelected = true
            item.categoryLabel.buttonfocused = true
        }
        
        return items
    }()

    
    /// button Tap -> change Apperance & GET call Breed Image by onChangeBreedTypeCompletion
    /// - Parameter sender: CategoryRoundedButton
    @objc func buttonTapped(_ sender: CategoryRoundedButton){
        
        if sender.isSelected == false {
            categoryButtonItems
                .forEach{data in
                    data.categoryButton.isSelected = false
                    data.categoryLabel.buttonfocused = false
                }
            
            sender.isSelected = true
            
            self.categoryButtonItems.forEach{ buttonlabel in
                if buttonlabel.categoryButton.isSelected == true{
                    buttonlabel.categoryLabel.buttonfocused = true
                    if let type = buttonlabel.categoryLabel.breedType{
                        onChangeBreedTypeCompletion(type)
                    }
                }
            }
            
        }
        
    }
    
    override init(frame: CGRect) {
        
        let changingBreedType = PublishSubject<BreedType>()

        onChangeBreedTypeCompletion = {type in changingBreedType.onNext(type)  }

        onChangeBreed = changingBreedType
        
        super.init(frame: frame)
        
        configure()
        
        
    }
    
    convenience init(frame: CGRect ,_ requestTypes: [BreedType]){
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
