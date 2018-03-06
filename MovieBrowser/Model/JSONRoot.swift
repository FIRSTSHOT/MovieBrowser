//
//  JSONRoot.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit

struct MoviesJSONRoot : Codable {
    var results : [Movie]?
}

struct GenresJSONRoot : Codable {
    var genres : [MovieGenre]?
}
