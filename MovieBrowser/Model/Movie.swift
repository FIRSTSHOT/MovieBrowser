//
//  Movie.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit

struct Movie : Codable, Equatable {
  
    var id: Int?
    var title: String?
    var overview: String?
    var releaseDate: String?
    var originalTitle: String?
    var isAdult: Bool?
    var voteCount: Int?
    var voteAverage: Double?
    var popularity: Double?
    var posterPath: String?
    var originalLanguage: String?
    var video: Bool?
    var isFavorite: Bool?
    var genreIds: [Int]?
    var runtime: Int?
    var genre: [MovieGenre]?
    var genreAndDuration: String?
   
    private enum CodingKeys : String, CodingKey {
        case id
        case title
        case overview
        case popularity
        case video
        case runtime
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case genreIds = "genre_ids"
        case isAdult = "adult"
        case isFavorite
        case genreAndDuration
        case genre
     }
    
    mutating func setIsFavorite(value : Bool)
    {
        isFavorite = value
    }
    
    mutating func setGenre(value: [MovieGenre])
    {
        genre = value
    }
    
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MovieGenre : Codable,Equatable {
  
    var id:Int?
    var name:String?
    
    private enum CodingKeys : String, CodingKey {
        case id
        case name
    }
    
    static func ==(lhs: MovieGenre, rhs: MovieGenre) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}

