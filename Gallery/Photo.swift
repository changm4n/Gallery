//
//  Photo.swift
//  Gallery
//
//  Created by changmin lee on 2020/02/03.
//  Copyright © 2020 changmin lee. All rights reserved.
//

import Foundation

struct Photo {
    
    var title: String
    var urlString: String
    var url: URL? {
        return URL(string: urlString)
    }
}
