//
//  NetworkService.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class NetworkService: NSObject {
    
    static let apiRoot = "https://api.themoviedb.org"
    static let posterApiRoot = "https://image.tmdb.org/t/p/w342"
    static var genresApi = "/3/genre/movie/list?api_key=98ddab1a678013f4f420946ce3d8b605&language=en-US"
    
    static func getMovieById(movieId:Int?, completion: @escaping (Movie?)->Void)
    {
        if let id = movieId {
            Alamofire.request(apiRoot+"/3/movie/"+id.toString+"?api_key=98ddab1a678013f4f420946ce3d8b605&language=en-US").responseData { (response) in
                if let data = response.data {
                    do{
                        let results = try JSONDecoder().decode(Movie.self, from: data)
                        let movie : Movie? = results
                        if movie != nil {
                            completion(movie)
                            return
                        }
                        completion(nil)
                        
                    }catch
                    {
                        completion(nil)
                        return
                    }
                }
            }
        }
    }
    
    static func getMoviePoster(posterUrl:String, completion : @escaping (UIImage?)->Void)
    {
        Alamofire.request(posterApiRoot + posterUrl).responseImage { response in
            if let image = response.result.value {completion(image)}
            else{completion(nil)}
        }
    }

    static func getAllMovies(apiUrl:String,completion : @escaping ([Movie]?) -> Void)
    {
        Alamofire.request(apiRoot+apiUrl).responseData { (response) in
            if let data = response.data {
                do{
                   var results = try JSONDecoder().decode(MoviesJSONRoot.self, from: data)
                    getAllMovieGenres(apiUrl: apiRoot + genresApi, completion: { (data) in
                        guard let genres = data else {
                             completion(nil)
                             return
                        }
                        // set genre for each movie
                        if let list = results.results {
                            for i in 0..<list.count {
                                var movieGenres : [MovieGenre] = []
                                if let idsList = list[i].genreIds {
                                    for j in 0..<idsList.count
                                    {
                                        for k in 0..<genres.count {
                                            if(idsList[j] == genres[k].id ){movieGenres.append(genres[k])}
                                        }
                                    }
                                }
                                results.results![i].setGenre(value: movieGenres)
                            }
                        }
                        completion(results.results)
                        return
                    })
                }catch
                {
                    completion(nil)
                    return
                }
            }
            
        }
    }
    
    static func getAllMovieGenres(apiUrl:String,completion : @escaping ([MovieGenre]?)-> Void)
    {
        Alamofire.request(apiRoot + genresApi).responseData { (response) in
            if let data = response.data {
                do
                {
                    let genres = try JSONDecoder().decode(GenresJSONRoot.self, from: data)
                    completion(genres.genres)
                }catch
                {
                    completion(nil)
                    return
                }
            }
        }
    }
}
