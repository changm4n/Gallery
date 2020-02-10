//
//  GalleryViewModel.swift
//  Gallery
//
//  Created by changmin lee on 2020/02/10.
//  Copyright © 2020 changmin lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Kanna

final class GalleryViewModel {
    //input
    let trigger = PublishSubject<Void>()
//    let refreshTrigger = PublishSubject<Void>()
    
    //output
    let output: BehaviorSubject<[Photo]> = BehaviorSubject(value: [])
    
    let disposeBag = DisposeBag()
    
    init() {
        self.setBindings()
    }
    
    private func setBindings() {
        trigger.flatMap({ GalleryService.getPhotoes() })
            .bind(to: output)
            .disposed(by: disposeBag)
    }
}

class GalleryService {
    static func getPhotoes() -> Observable<[Photo]> {
        return RxAlamofire.requestString(.get, "https://www.gettyimagesgallery.com/collection/slim-aarons-snow/").flatMap({
            parse(html: $1)
        })
    }
    
    static func parse(html: String) -> Observable<[Photo]> {
        return Observable<[Photo]>.create { (oo) -> Disposable in
            print("load")
            var photos: [Photo] = []
            guard let doc = try? Kanna.HTML(html: html, encoding: .utf8) else {
                oo.onNext([])
                return Disposables.create()
            }
            
            for item in doc.css("img[class='jq-lazy']") {
                guard let title = item["alt"], let url = item["data-src"] else {
                    oo.onNext([])
                    return Disposables.create()
                }
                let p = Photo(title: title, urlString: url)
                photos.append(p)
            }
            
            oo.onNext(photos)
            oo.onCompleted()
            
            return Disposables.create()
        }.subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
}
