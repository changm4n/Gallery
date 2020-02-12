//
//  GalleryCell.swift
//  Gallery
//
//  Created by changmin lee on 2020/02/03.
//  Copyright © 2020 changmin lee. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class GalleryCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    let imageView: UIImageView = {
        let iv = UIImageView(frame: CGRect.zero)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        
        self.setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func setLayout() {
        imageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    func bind(item: Photo) {
        guard let url = item.url else { return }
        
        //For @2x
        var size = self.imageView.frame.size
        size.width *= 2
        size.height *= 2
        
        GalleryService.shared.getImage(byURL: url, size: size)
            .asDriver(onErrorJustReturn: UIImage())
            .drive(self.imageView.rx.image)
        .disposed(by: disposeBag)
    }
}
