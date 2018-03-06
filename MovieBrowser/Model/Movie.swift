//
//  Movie.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit


struct Movie: Codable,Equatable {
    
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    
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
    var genreAndDuration:String?
    
    mutating func setIsFavorite(value : Bool)
    {
        self.isFavorite = value
    }
    
    mutating func setGenre(value: [MovieGenre])
    {
        genre = value
    }
    
}

struct MovieGenre : Codable,Equatable {
    static func ==(lhs: MovieGenre, rhs: MovieGenre) -> Bool {
         return lhs.id == rhs.id 
    }
    
    var id:Int?
    var name:String?
}

