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
                
                 let results = try JSONDecoder().decode(JSONRoot.self, from: responseData)
                
                if let list = results.results {
                    completion(list)
                    return
                }
                
                completion(nil)
                
            }catch
            {
                completion(nil)
                return
            }
            
        }
        
        task.resume()
        
    }

}
