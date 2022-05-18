//
//  DetailViewController.swift
//  SideDishApp
//
//  Created by 박진섭 on 2022/04/20.
//

import UIKit
import OSLog

final class DetailViewController: UIViewController {
    
    private var networkRepositroy: NetworkRepository<ImageCacheManager>?
    private let menu: Menu
    private let detailScrollView = DetailScrollView()
    
    private var menuDetail: MenuDetail? {
        didSet {
            setDetailView(by: menuDetail)
        }
    }
    
    init(menu: Menu) {
        self.menu = menu
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpDelegate()
    }
    
    private func setUpView() {
        configureView()
        view.addSubview(detailScrollView)
        configureMenuStackView()
        layoutDetailScrollView()
    }
    
    private func configureView() {
        title = menu.title
    }
    
    private func setUpDelegate() {
        detailScrollView.overViewImageScrollView.delegate = self
        detailScrollView.countStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .touchUpInside)
    }
    
    private func configureMenuStackView() {
        detailScrollView.mainInfoStackView.setTitle(by: menu.title)
        detailScrollView.mainInfoStackView.setDescription(by: menu.description)
        detailScrollView.mainInfoStackView.setPrice(originPrice: menu.n_price, discountedPrice: menu.s_price)
        detailScrollView.mainInfoStackView.setBadges(by: menu.badge)
    }
    
    private func setDetailView(by menuDetail: MenuDetail?) {
        guard let menuDetail = menuDetail else { return }
        setSubInfo(by: menuDetail)
        setThumbNail(imageURLStrings: menuDetail.thumb_images)
        setRecipe(imageURLStrings: menuDetail.detail_section)
    }
    
    private func setSubInfo(by menuDetail: MenuDetail) {
        let descriptions = [menuDetail.point, menuDetail.delivery_info, menuDetail.delivery_fee]
        detailScrollView.subInfoStackView.setSubInfoDescription(by: descriptions)
        
        guard let price = menuDetail.prices.last else { return }
        detailScrollView.setPrice(text: price)
    }
}

// MARK: - View Layout

extension DetailViewController {
    private func layoutDetailScrollView() {
        detailScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        detailScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        detailScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        detailScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        detailScrollView.imagePageControl.currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
    }
}

// MARK: - Providing Function

extension DetailViewController {
    func setMenuDetail(menuDetail: MenuDetail?) {
        self.menuDetail = menuDetail
    }
}

// MARK: - Selector Function

extension DetailViewController {
    @objc func stepperValueChanged(_ sender: UIStepper!) {
        let count = Int(sender.value)
        detailScrollView.orderCount = count
        
        guard let stringPrice = menuDetail?.prices.last else { return }
        let decimalPrice = PriceConvertor.toDecimal(from: stringPrice)
        let stringAmount = decimalPrice * count
        let decimalAmount = PriceConvertor.toString(from: stringAmount)
        detailScrollView.amount = decimalAmount
    }
}

extension DetailViewController {
    
    func setThumbNail(imageURLStrings: [String]) {
        
        networkRepositroy = NetworkRepository(
            networkManager: ImageNetworkManager(session: .shared),
            cacheManager: ImageCacheManager.shared
        )
        
        detailScrollView.setOverViewImageScrollContentSize(imageCount: imageURLStrings.count)
        
        for (index, imageURLString) in imageURLStrings.enumerated() {
            guard let imageURL = URL(string: imageURLString) else { return }
            networkRepositroy?.fetchData(endpoint: EndPointCase.getImage(imagePath: imageURL.path).endpoint,
                                         decodeType: Data.self,
                                         onCompleted: { [weak self] imageData in
                guard let self = self,
                      let imageData = imageData,
                      let image = UIImage(data: imageData) else { return }
                DispatchQueue.main.async {
                    self.detailScrollView.insertThumbNail(image: image, at: index)
                    }
                }
            )
        }
    }
    
    func setRecipe(imageURLStrings: [String]) {
        networkRepositroy = NetworkRepository(
            networkManager: ImageNetworkManager(session: .shared),
            cacheManager: ImageCacheManager.shared
        )
        
        detailScrollView.addPlaceholderView(count: imageURLStrings.count)
        
        for (index, imageURLString) in imageURLStrings.enumerated() {
            guard let imageURL = URL(string: imageURLString) else { return }
            
            networkRepositroy?.fetchData(endpoint: EndPointCase.getImage(imagePath: imageURL.path).endpoint,
                                         decodeType: Data.self,
                                         onCompleted: { [weak self] imageData in
                guard let self = self,
                      let imageData = imageData,
                      let image = UIImage(data: imageData) else { return }
                DispatchQueue.main.async {
                    self.detailScrollView.setRecipe(image: image, at: index)
                    }
                }
            )
        }
    }
}
