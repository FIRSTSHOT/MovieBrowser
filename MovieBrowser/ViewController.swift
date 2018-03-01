//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var movies : [Movie]?
    @IBOutlet weak var tableView: UITableView!
    
    var api = "https://api.themoviedb.org/3/discover/movie?api_key=98ddab1a678013f4f420946ce3d8b605&language=en-US&sort_by=popularity.desc&page=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getMovies { (data) in
            
            self.movies = data
            
            self.tableView.reloadData()
        }

        
    }
    
    func getMovies(completion: @escaping ([Movie]) -> Void) {
        
        NetworkService.getAllMovies(apiUrl: api) { (data) in
            
            guard let movies = data else {
                return
            }
            
            completion(movies)
            
        }
    
        
    }



}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let title = movies![indexPath.row].title {
            
            cell.textLabel?.text = title
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.movies == nil {
            return 0
        }
        return (self.movies?.count)!
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

