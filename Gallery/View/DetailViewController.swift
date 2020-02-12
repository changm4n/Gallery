//
//  DetailViewController.swift
//  Gallery
//
//  Created by changmin lee on 2020/02/12.
//  Copyright © 2020 changmin lee. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DetailViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    var photo: Photo?
    
    let imageView: UIImageView = {
        let iv = UIImageView(frame: CGRect.zero)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect.zero)
        sv.minimumZoomScale = 1
        sv.maximumZoomScale = 4.0
        sv.zoomScale = 1.0
        return sv
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel(frame: CGRect.zero)
        lb.textAlignment = .center
        return lb
    }()
    
    override func setupBind() {
        GalleryService.shared.getImage(byURL: self.photo?.url)
            .asDriver(onErrorJustReturn: UIImage())
            .drive(self.imageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        self.title = "Detail View"
        self.view.backgroundColor = .white
        self.scrollView.delegate = self
        
        self.titleLabel.text = self.photo?.title ?? "No title"
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(imageView)
        
        layout()
    }  
}

//MARK : Set Layout
extension DetailViewController {
    
    func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        scrollView.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        })
        
        imageView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
}

//MARK : UIScrollViewDelegate
extension DetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
