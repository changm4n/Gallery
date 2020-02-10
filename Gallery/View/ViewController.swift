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
import Alamofire
import Kanna

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
        self.viewModel.output.asDriver(onErrorJustReturn: []).drive(self.collectionView.rx.items(cellIdentifier: "GalleryCell", cellType: GalleryCell.self)) { collectionView, item, cell in
            cell.bind(item: item)
        }.disposed(by: disposeBag)
        
        self.viewModel.output.observeOn(MainScheduler.instance).subscribe { (_) in
            self.refreshControl.endRefreshing()
        }.disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDelegate {
    
    func setLayout() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


