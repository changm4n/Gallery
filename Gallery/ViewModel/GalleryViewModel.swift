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

final class GalleryViewModel {
    
    let disposeBag = DisposeBag()
    
    //input
    let trigger = PublishSubject<Void>()
    
    //output
    let output: BehaviorSubject<[Photo]> = BehaviorSubject(value: [])
    
    init() {
        self.setBindings()
    }
    
    private func setBindings() {
        trigger.flatMap({ GalleryService.shared.getHTML()
            .flatMap({ GalleryService.shared.parse(html: $0) })
        })
            .bind(to: output)
            .disposed(by: disposeBag)
    }
}
