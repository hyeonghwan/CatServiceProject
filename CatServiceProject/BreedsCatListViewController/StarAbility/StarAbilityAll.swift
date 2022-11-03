//
//  StarAbilityAll.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/11/02.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class StarAbilityAll: UIView {
    
    var abilityObserver: AnyObserver<Breed?>
    
    var disposeBag = DisposeBag()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var adaptability: StarView = {
        let view = StarView()
        return view
    }()
    
    lazy var affectionLevel: StarView = {
        let view = StarView()
        return view
    }()
    
    lazy var childFriendly: StarView = {
        let view = StarView()
        return view
    }()
    
    lazy var dogFriendly: StarView = {
        let view = StarView()
        return view
    }()

    lazy var energyLevel: StarView = {
        let view = StarView()
        return view
    }()
    
    lazy var grooming: StarView = {
        let view = StarView()
        return view
    }()
    
    lazy var healthIssues: StarView = {
        let view = StarView()
        return view
    }()
    
    lazy var intelligence: StarView = {
        let view = StarView()
        return view
    }()
    
    lazy var sheddingLevel: StarView = {
        let view = StarView()
        return view
    }()
    
    lazy var socialNeeds: StarView = {
        let view = StarView()
        return view
    }()
    
    lazy var strangerFriendly: StarView = {
        let view = StarView()
        return view
    }()
    
    lazy var vocalisation: StarView = {
        let view = StarView()
        return view
    }()
    
    lazy var viewDic2 : [String : StarView] =  ["adaptability" : adaptability,
                                      "affectionLevel": affectionLevel,
                                      "childFriendly": childFriendly,
                                      "dogFriendly": dogFriendly,
                                      "energyLevel": energyLevel,
                                      "grooming": grooming,
                                      "healthIssues": healthIssues,
                                      "intelligence": intelligence,
                                      "sheddingLevel": sheddingLevel,
                                      "socialNeeds": socialNeeds,
                                      "strangerFriendly": strangerFriendly,
                                      "vocalisation": vocalisation]
   
    
    override init(frame: CGRect) {
        
        let pipe = PublishSubject<Breed?>()
        
        abilityObserver = pipe.asObserver()
        
        super.init(frame: frame)
        
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints{
            $0.leading.equalToSuperview()
        }
        
        [adaptability,
         affectionLevel,
         childFriendly,
         dogFriendly,
         energyLevel,
         grooming,
         healthIssues,
         intelligence,
         sheddingLevel,
         socialNeeds,
         strangerFriendly,
         vocalisation]
            .forEach{
                stackView.addArrangedSubview($0)
                
            }
        
        pipe.bind(onNext: {[weak self] breed in
            guard let self = self else {return}
            guard let breed = breed else {return}
            let ability = Breed.getAbility(breed)
            
            var count = 0
            ["adaptability",
             "affectionLevel",
             "childFriendly",
             "dogFriendly",
             "energyLevel",
             "grooming",
             "healthIssues",
             "intelligence",
             "sheddingLevel",
             "socialNeeds",
             "strangerFriendly",
             "vocalisation"].forEach{ key in
                
                DispatchQueue.main.async {
                    self.viewDic2[key]?.starLabel.text = key
                    self.viewDic2[key]?.star.current = CGFloat(ability[count])
                    count += 1
                }
            }
        }).disposed(by: disposeBag)
        
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
}
