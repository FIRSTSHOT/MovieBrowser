//
//  Movie.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit

class Movie: NSObject {
    
    var id:Int?
    var title:String?
    var overview:String?
    var release_date:String?
    var original_title:String?
    var isAdult:Bool?
    var vote_count:Int?
    var vote_average:Int?
    var popularity:Double?
    var poster_path:String?
    var original_language:String?
    var isVideo:Bool?
    
    init?(json: [String:Any]) {
        
        guard let result  = json["results"] as? [String:Any] else {
            return nil
        }
        
        guard let id = result["id"] as? Int,
            let title = result["title"] as? String,
            let overview = result["overview"] as? String,
            let release_date = result["release_date"] as? String,
            let original_title = result["original_title"] as? String,
            let isAdult = result["isAdult"] as? Bool,
            let vote_count = result["vote_count"] as? Int,
            let vote_average = result["vote_average"] as? Int,
            let popularity = result["popularity"] as? Double,
            let poster_path = result["poster_path"] as? String,
            let original_language = result["original_language"] as? String,
            let isVideo = result["isVideo"] as? Bool else {
                return nil
        }
        
        self.id = id
        self.title = title
        self.overview = overview
        self.release_date = release_date
        self.original_title = original_title
        self.isAdult = isAdult
        self.vote_count = vote_count
        self.vote_average = vote_average
        self.popularity = popularity
        self.poster_path = poster_path
        self.original_language = original_language
        self.isVideo = isVideo
        
        
    }
    
}
