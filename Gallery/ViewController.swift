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
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    let output: PublishSubject<[Photo]> = PublishSubject()
    
    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: CMCollectionViewLayout())
        cv.backgroundColor = .white
        cv.register(GalleryCell.self, forCellWithReuseIdentifier: "GalleryCell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadHTML()
    }
    
    override func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        setLayout()
    }
    
    override func setupBind() {
        output.asDriver(onErrorJustReturn: []).drive(self.collectionView.rx.items(cellIdentifier: "GalleryCell", cellType: GalleryCell.self)) { collectionView, item, cell in
            cell.bind(item: item)
        }.disposed(by: disposeBag)
    }
    
    private func loadHTML() {
        Alamofire.request("https://www.gettyimagesgallery.com/collection/slim-aarons-snow/", method: .get).responseString { [weak self] (response) in
            if let html = response.result.value {
                self?.parse(html: html)
            }
        }
    }
    
    private func parse(html: String) {
        var photos: [Photo] = []
        if let doc = try? Kanna.HTML(html: html, encoding: .utf8) {
            for item in doc.css("img[class='jq-lazy']") {
                guard let title = item["alt"], let url = item["data-src"] else {
                    return
                }
                let p = Photo(title: title, urlString: url)
                photos.append(p)
            }
        }
        output.onNext(photos)
    }
}

extension ViewController: UITableViewDelegate {
    
    func setLayout() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

