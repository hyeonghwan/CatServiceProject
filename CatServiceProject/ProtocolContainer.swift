//
//  ProtocolContainer.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/20.
//

import Foundation


class ViewModelContainer {
    
    var mainViewModel : CatMainViewModel
    var favouriteViewModel: CatFavouriteViewModel
    
    
    init(_ m: CatMainViewModel,_ f: CatFavouriteViewModel){
        self.mainViewModel = m
        self.favouriteViewModel = f
    }
    
    func makeViewModel(_ viewModel: ViewModelType) -> ViewModelType? {
        switch viewModel{
        case is CatFavouriteViewModel:
            return CatFavouriteViewModel(CatService2(),
                                         self.mainViewModel.favouriteSuccessObservable,
                                         self.mainViewModel)
        case is CatMainViewModel:
            return CatMainViewModel(catService: CatService2(),
                                    favouriteModel: self.favouriteViewModel)
            
        default:
            return nil
        }
    }
    
}
