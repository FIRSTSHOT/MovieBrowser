//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var movies : [Movie] = []
    var selectedMovie: Movie?
    var favoriteMovies : [Movie] = []
    var defaults = UserDefaults.standard

    
    @IBOutlet weak var tableView: UITableView!
    
    var api = "https://api.themoviedb.org/3/discover/movie?api_key=98ddab1a678013f4f420946ce3d8b605&language=en-US&sort_by=popularity.desc&page=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        if let favoritesData = UserDefaults.standard.data(forKey: "favMovies")
        {
            favoriteMovies = try! JSONDecoder().decode([Movie].self, from: favoritesData)
        }
        
        getMovies { (data) in
            
            self.movies = data
            
            DispatchQueue.main.async {
                self.tableView.reloadInputViews()
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(true)
        
        self.tableView.reloadData()
    }
    
    func getMovies(completion: @escaping ([Movie]) -> Void) {
        
        NetworkService.getAllMovies(apiUrl: api) { (data) in
            
            guard let movies = data else {
                return
            }
            completion(movies)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailViewController {
            
            
            destination.delegate = self
            destination.selectedMovie = selectedMovie
            
            
        }
    }


}

extension ViewController : UITableViewDelegate,UITableViewDataSource,MovieDetailViewControllerDelegate {
    
    
    func selectedFavoriteMovie(favorite: Movie) {
        
        favoriteMovies.append(favorite)
       let favoritesData = try! JSONEncoder().encode(favoriteMovies)
        UserDefaults.standard.set(favoritesData, forKey: "favMovies")
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        switch indexPath.section {
        case 0:
            if let title = movies[indexPath.row].title {
                
                cell.textLabel?.text = title
            }
            break
        case 1:
            
            if let title = favoriteMovies[indexPath.row].title {
                
                cell.textLabel?.text = title
            }
            break
            
        default: break
            
        }
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch section {
        case 0:
        
            return (self.movies.count)
        case 1:
            return (self.favoriteMovies.count)
        default:
            return 0
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 :
            return "Movies"
        case 1 :
            return "Favorites"
        default:
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "showMovieDetailSegue", sender: self)
        
    }
    
}

