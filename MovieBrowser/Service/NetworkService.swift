//
//  NetworkService.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit

class NetworkService: NSObject {
    
    static func getAllMovies(apiUrl:String,completion : @escaping ([Movie]?) -> Void)
    {
        
        var movieList = [Movie]()
        
        guard let url = URL(string: apiUrl) else {
             print("Error: cannot create URL")
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let responseData = data else
            {
                completion(nil)
                return
            }
            
            do{
                
                if let dataJson = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:Any]
                {

                    guard let results = dataJson["results"] as? [Any] else {
                        
                        
                        completion(nil)
                        return
                    }

                    for i in 0..<results.count {
                        
                        guard let movieJson = results[i] as? Dictionary<String,Any> else {
                            completion(nil)
                            return
                        }
                        
                        if let  movie = Movie(json: movieJson) {
                              movieList.append(movie)
                        }else{
                            print("error appending")
                        }

                        
                    }
                    
                    if(!movieList.isEmpty) {
                        completion(movieList)
                        return
                    }
                    
                    completion(nil)
                    
                
                    
                }
                
            }catch
            {
                return
            }
            
        }
        
        task.resume()
        
    }

}