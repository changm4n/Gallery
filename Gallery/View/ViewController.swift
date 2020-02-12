//
//  ViewController.swift
//  Gallery
//
//  Created by changmin lee on 2020/02/02.
//  Copyright © 2020 changmin lee. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: BaseViewController {
    
    private let viewModel = GalleryViewModel()
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: CMCollectionViewLayout())
        cv.backgroundColor = .white
        cv.register(GalleryCell.self, forCellWithReuseIdentifier: "GalleryCell")
        return cv
    }()
    
    var refreshControl = UIRefreshControl()
    
    override func setupUI() {
        self.title = "Gallery"
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        self.collectionView.refreshControl = refreshControl
        
        setLayout()
    }
    
    override func setupBind() {
        //Initial Load
        self.viewModel.trigger.onNext(())
        
        //Input Binding
        self.refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.trigger).disposed(by: disposeBag)
        
        //Output Binding
        self.viewModel.output.asDriver(onErrorJustReturn: [])
            .drive(self.collectionView.rx.items(cellIdentifier: "GalleryCell",
                                                cellType: GalleryCell.self)) { collectionView, item, cell in
            cell.bind(item: item)
        }.disposed(by: disposeBag)
        
        self.viewModel.output
            .observeOn(MainScheduler.instance)
            .subscribe { (_) in
            self.refreshControl.endRefreshing()
        }.disposed(by: disposeBag)
        
        self.collectionView.rx
            .modelSelected(Photo.self)
            .subscribe(onNext: { [weak self] (model) in
                let vc = DetailViewController()
                vc.photo = model
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
}

//MARK : Set Layout
extension ViewController: UITableViewDelegate {
    
    func setLayout() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
