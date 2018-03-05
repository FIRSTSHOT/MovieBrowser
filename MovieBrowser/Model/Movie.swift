//
//  Movie.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit

class Movie: Codable {
    
    var id:Int?
    var title:String?
    var overview:String?
    var release_date:String?
    var original_title:String?
    var adult:Bool?
    var vote_count:Int?
    var vote_average:Double?
    var popularity:Double?
    var poster_path:String?
    var original_language:String?
    var video:Bool?
    var isFavorite:Bool?
    var genre_ids:[Int]?
    var runtime:Int?
    var genre:[MovieGenre]?
    
}

class MovieGenre : Codable {
    var id:Int?
    var name:String?
}

