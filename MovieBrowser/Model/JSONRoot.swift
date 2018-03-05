//
//  JSONRoot.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit

class MoviesJSONRoot: Codable {
    
    let results : [Movie]?

}

class GenresJSONRoot: Codable {
    
    let genres : [MovieGenre]?
    
}
