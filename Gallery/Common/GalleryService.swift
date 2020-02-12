//
//  GalleryService.swift
//  Gallery
//
//  Created by changmin lee on 2020/02/12.
//  Copyright © 2020 changmin lee. All rights reserved.
//

import Foundation
import RxSwift
import Kanna
import SDWebImage
import RxAlamofire

class GalleryService {
    
    static let shared = GalleryService()
    
    let BASE_URL = "https://www.gettyimagesgallery.com/collection/slim-aarons-snow/"
    
    func getHTML() -> Observable<String> {
        return RxAlamofire.requestString(.get, self.BASE_URL).map{ $1 }
    }
    
    func parse(html: String) -> Observable<[Photo]> {
        return Observable<[Photo]>.create { (observable) -> Disposable in
            var photos: [Photo] = []
            guard let doc = try? Kanna.HTML(html: html, encoding: .utf8) else {
                observable.onNext([])
                return Disposables.create()
            }
            
            for item in doc.css("div[class=item-wrapper]") {
                guard let title = item.css("h5[class=image-title]").first?.content,
                    let url = item.css("img").first?["data-src"] else {
                    observable.onNext([])
                    return Disposables.create()
                }
                let p = Photo(title: title, urlString: url)
                photos.append(p)
            }
            
            observable.onNext(photos)
            observable.onCompleted()
            
            return Disposables.create()
        }.subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func getImage(byURL url: URL?, size: CGSize? = nil) -> Observable<UIImage> {
        var context: [SDWebImageContextOption: Any]? = nil
        if let size = size {
            context = [.imageThumbnailPixelSize : size]
        }
        
        return Observable<UIImage>.create { (observable) -> Disposable in
            SDWebImageManager.shared.loadImage(
                with: url,
                options: .highPriority,
                context: context,
                progress: nil) {  (image, data, error, cacheType, finish, url) in
                    
                    if let error = error {
                        observable.onError(error)
                    }
                    
                    if let image = image {
                        observable.onNext(image)
                        observable.onCompleted()
                    }
            }
            return Disposables.create()
        }.subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}
