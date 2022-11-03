//
//  MainViewController.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/06.
//

import UIKit
import SnapKit
import MGStarRatingView
import RxCocoa
import RxSwift

protocol CustomSegmentedControlDelegate: AnyObject{
    func changeToIndex(index: Int)
}

final class CatBreedsListViewController: UIViewController, StarRatingDelegate{
    
    func StarRatingValueChanged(view: MGStarRatingView.StarRatingView, value: CGFloat) {
        
    }
    
    let breedViewModel = CatBreedsViewModel()
    
    var disposeBag = DisposeBag()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private lazy var categorySegemts: CategoryView = {
       let segment = CategoryView()
        return segment
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var ratingView: CatBreedsStarRatingView = {
        let rating = CatBreedsStarRatingView()
        return rating
    }()

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CatBreedHorizontalCell.self,
                                forCellWithReuseIdentifier: CatBreedHorizontalCell.identify)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
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
        
        if let breedType = CategoryButtonAndLabel.dummyData().first{
            breedViewModel.getBVMCatImages(breedType){ [weak self] models in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    self.pageControlSetting()
                }
            }
        }
        
        categorySegemts
            .getObservableBreedType()
            .subscribe(onNext: breedViewModel.onBreedsDataObserver.onNext(_:))
            .disposed(by: disposeBag)
        
        breedViewModel
            .onHSCDataObservable
            .map{ breeds in return breeds.first}
            .do(onNext: { [weak self] breed in
                guard let self = self else { return }
                guard let breed = breed else { return }
                self.headerLabel.rx.text.onNext(breed.name)
            })
            .subscribe(onNext: ratingView.starAbilityView.abilityObserver.onNext(_:))
            .disposed(by: disposeBag)
        
        
        breedViewModel
            .pagingCountObservable
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        configure()
        
    }
    
    func pageControlSetting(){
        self.pageControl.numberOfPages = self.breedViewModel.numberOfPageContolCount()
        self.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    
    func configure() {
        
        self.navigationItem.title = "Cat Service"
        
        view.backgroundColor = .systemBackground
        
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        categorySegemts.backgroundColor = .systemCyan

        scrollView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        
        [categorySegemts,headerLabel,collectionView,pageControl,ratingView].forEach{
            contentView.addSubview($0)
        }
        
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
        }
        
        categorySegemts.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(110)
            $0.leading.trailing.equalToSuperview()
        }
        
        headerLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(categorySegemts.snp.bottom).offset(10)
        }
        
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(headerLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        pageControl.snp.makeConstraints{
            $0.top.equalTo(collectionView.snp.bottom).offset(-24)
            $0.centerX.equalToSuperview()
        }
        
        ratingView.snp.makeConstraints{
            $0.top.equalTo(pageControl.snp.bottom).offset(10)
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
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
            self.collectionView.scrollToItem(at: IndexPath(row: breedViewModel.numberOfPageContolCount(), section: 0),
                                             at: .left,
                                             animated: true)
            self.pageControl.currentPage = breedViewModel.numberOfPageContolCount()
            
        }else if (page == CGFloat(self.breedViewModel.numberOfSection() - 1) ) {
            self.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: true)
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
        
        let url = breedViewModel.breedCellModels?[indexPath.row].imageURL
        
        if let url = url{
            cell.updateUI(url)
        }
        
        return cell
    }
    
}

