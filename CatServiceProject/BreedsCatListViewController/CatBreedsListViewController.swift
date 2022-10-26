//
//  MainViewController.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/06.
//

import Foundation
import UIKit
import SnapKit

protocol CustomSegmentedControlDelegate: AnyObject{
    func changeToIndex(index: Int)
}

final class CatBreedsListViewController: UIViewController{
    
    let breedViewModel = CatBreedsViewModel()
    
    lazy var categorySegemts: CategoryView = {
       let segment = CategoryView()
        return segment
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CatBreedHorizontalCell.self,
                                forCellWithReuseIdentifier: CatBreedHorizontalCell.identify)
        collectionView.isPagingEnabled = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = .systemGray
        page.currentPageIndicatorTintColor = .systemBlue
        page.numberOfPages = 3
        page.addTarget(self, action: #selector(handlePageControl(_:)), for: .valueChanged)
        return page
    }()
    
    @objc func handlePageControl(_ sender: UIPageControl){
        if sender.currentPage == 0{
            let indexPath = IndexPath(row: sender.currentPage + 1, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            
        }else if sender.currentPage == self.breedViewModel.numberOfSection() - 2 {
            let indexPath = IndexPath(row: sender.currentPage - 1, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            
        }else {
            let indexPath = IndexPath(row: sender.currentPage + 1, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        breedViewModel.breedCellHandler = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
            }
        }
        
        breedViewModel.getCatBreedsData{ [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.pageControl.numberOfPages = self.breedViewModel.numberOfSection() - 2
                self.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
        
        
        
        configure()
        
    }
    func configure() {
        
        self.navigationItem.title = "Cat Service"
        view.backgroundColor = .systemBackground
        
        [categorySegemts,collectionView,pageControl].forEach{
            self.view.addSubview($0)
        }
        categorySegemts.backgroundColor = .systemCyan

        categorySegemts.snp.makeConstraints{
            
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.height.equalTo(110)
            $0.leading.trailing.equalToSuperview()
        }
        
        collectionView.backgroundColor = .orange
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(categorySegemts.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        pageControl.snp.makeConstraints{
            $0.top.equalTo(collectionView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
}
extension CatBreedsListViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        let page = round(fractionalPage)
        self.pageControl.currentPage = Int(page - 1)
        
        if page == 0{
            self.collectionView.scrollToItem(at: IndexPath(row: self.breedViewModel.numberOfSection() - 2, section: 0), at: .left, animated: false)
            self.pageControl.currentPage = self.breedViewModel.numberOfSection() - 2
        }else if (page == CGFloat(self.breedViewModel.numberOfSection() - 1) ) {
            self.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: false)
            self.pageControl.currentPage = 0
        }
    }
}

extension CatBreedsListViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Position.screenWidth - 50 , height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
}

extension CatBreedsListViewController: UICollectionViewDelegate{
    
}

extension CatBreedsListViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedViewModel.numberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: CatBreedHorizontalCell.identify, for: indexPath) as? CatBreedHorizontalCell else {return UICollectionViewCell()}
        
        let url = breedViewModel.breedCellModels?[indexPath.row].imageModel?.imageURL
        
        if let url = url{
            cell.updateUI(url)
        }
        
        return cell
    }
    
}

