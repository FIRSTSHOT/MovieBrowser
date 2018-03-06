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
        Alamofire.request(apiRoot+"/3/movie/"+(movieId?.toString)!+"?api_key=98ddab1a678013f4f420946ce3d8b605&language=en-US").responseData { (response) in
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
    
    
    static func getMoviePoster(posterUrl:String, completion : @escaping (UIImage?)->Void)
    {
        
     
        Alamofire.request(posterApiRoot + posterUrl).responseImage { response in
            if let image = response.result.value {
                completion(image)
            }
            else
            {
                completion(nil)
            }
        }
        
    }

    static func getAllMovies(apiUrl:String,completion : @escaping ([Movie]?) -> Void)
    {
        Alamofire.request(apiRoot+apiUrl).responseData { (response) in
            if let data = response.data {
                do{
                    
                   var results = try JSONDecoder().decode(MoviesJSONRoot.self, from: data)
                    
                    getAllMovieGenres(apiUrl: apiRoot+genresApi, completion: { (data) in
                        
                        
                        guard let genres = data else {

                            return
                        }
                        
                        
                        if let list = results.results {
                            
                            for i in 0..<list.count {
                                
                                var movieGenres : [MovieGenre] = []
                                
                                if let idsList = list[i].genre_ids {
                                    
                                    for j in 0..<idsList.count
                                    {

                                        for k in 0..<genres.count {
     
                                            if(idsList[j] == genres[k].id )
                                            {
                                                movieGenres.append(genres[k])
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                }
                                results.results![i].setIsFavorite(value: false)
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
    
//    static func getAllMovies(apiUrl:String,completion : @escaping ([Movie]?) -> Void)
//    {
//
//        guard let url = URL(string: apiRoot + apiUrl) else {
//             print("Error: cannot create URL")
//            completion(nil)
//            return
//        }
//
//        let urlRequest = URLRequest(url: url)
//        let session = URLSession.shared
//        let task = session.dataTask(with: urlRequest) { (data, response, error) in
//
//            guard error == nil else {
//                completion(nil)
//                return
//            }
//
//            guard let responseData = data else
//            {
//                completion(nil)
//                return
//            }
//
//            do{
//
//                 let results = try JSONDecoder().decode(JSONRoot.self, from: responseData)
//
//                if let list = results.results {
//                    completion(list)
//                    return
//                }
//
//                completion(nil)
//
//            }catch
//            {
//                completion(nil)
//                return
//            }
//
//        }
//
//        task.resume()
//
//    }
    
    //    static func getMoviePoster(posterUrl:String, completion : @escaping (UIImage?)->Void)
    //    {
    //        guard let url = URL(string: "https://www.joblo.com/posters/images/full/loganimaxposter.jpg") else {
    //            print("Error: cannot create URL")
    //            completion(nil)
    //            return
    //        }
    //
    //        print(url)
    //
    //        let urlRequest = URLRequest(url: url)
    //        let session = URLSession.shared
    //
    //        let task = session.dataTask(with: urlRequest) { (data, response, error) in
    //            guard error == nil else {
    //                completion(nil)
    //                return
    //            }
    //
    //            guard let responseData = data else
    //            {
    //                completion(nil)
    //                return
    //            }
    //
    //            do{
    //                let downloadedImage = UIImage(data: responseData)
    //                completion(downloadedImage)
    //
    //            }catch
    //            {
    //                completion(nil)
    //
    //            }
    //
    //
    //        }
    //
    //        task.resume()
    //
    //    }
    //


}
