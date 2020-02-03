//
//  GalleryCell.swift
//  Gallery
//
//  Created by changmin lee on 2020/02/03.
//  Copyright © 2020 changmin lee. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import SnapKit

class GalleryCell: UICollectionViewCell {
    
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
    
    func setLayout() {
        imageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(item: Photo) {
        guard let url = item.url else { return }
        
        SDWebImageManager.shared.loadImage(
            with: url,
            options: .continueInBackground,
            context: [.imageThumbnailPixelSize : self.imageView.frame.size],
            progress: nil) { [weak self] (image, data, error, cacheType, finish, url) in
                guard let this = self else { return }
                this.imageView.image = image
                if cacheType == .none {
                    print("non - cache")
                }
        }
    }
}
