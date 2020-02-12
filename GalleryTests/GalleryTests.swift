//
//  GalleryTests.swift
//  GalleryTests
//
//  Created by changmin lee on 2020/02/02.
//  Copyright © 2020 changmin lee. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift

@testable import Gallery

class GalleryTests: XCTestCase {

    let disposeBag = DisposeBag()
    let sampleHTML = """
<div class="item-wrapper">
  <img class="jq-lazy" data-src="https://www.gettyimagesgallery.com/wp-content/uploads/2019/07/GettyImages-1158180907.jpg" alt="Gstaad Town Centre from Slim Aarons Snow fine art photography" />
  <div class="text-wrapper mt-auto">
    <h5 class="image-title">Gstaad Town Centre</h5>
    <button class="btn btn-primary btn-enquire" data-id="6728" >Enquire</button>
  </div>
</div>
"""
    let TIMEOUT: TimeInterval = 5

    func testGetHTML() {
        let promise = expectation(description: "Completion handler invoked")
        
        GalleryService.shared.getHTML().subscribe(onNext: { (html) in
            promise.fulfill()
        }, onError: { (error) in
            XCTAssertThrowsError("error")
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: TIMEOUT, handler: nil)
    }
    
    func testParsing() {
        let promise = expectation(description: "Completion handler invoked")
        
        GalleryService.shared.parse(html: sampleHTML).subscribe(onNext: { (photos) in
            XCTAssertNotNil(photos.first)
            promise.fulfill()
        }, onError: { (error) in
            XCTAssertThrowsError("parsing error")
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: TIMEOUT, handler: nil)
    }
    
    func testGetImage() {
        let promise = expectation(description: "Completion handler invoked")
        
        let url = URL(string: "https://www.gettyimagesgallery.com/wp-content/uploads/2019/07/GettyImages-1158180907.jpg")
        GalleryService.shared.getImage(byURL: url).subscribe(onNext: { (image) in
            promise.fulfill()
        }, onError: { (error) in
            XCTAssertThrowsError("get image error")
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: TIMEOUT, handler: nil)
    }
}
