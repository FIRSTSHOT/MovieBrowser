//
//  FavoriteMoviesTableViewController.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class FavoriteMoviesTableViewController: UITableViewController {

    var favoriteMovies : [Movie] = []
    var selectedMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getFavoriteMovies()
        
    
    }
    
    func getFavoriteMovies() {
        let fileName = "favs.json"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(fileName)
            do
            {
                let favMoviesJson = try String(contentsOf: fileURL, encoding: .utf8)
                
                
                do
                {
                    if let favoritesData = favMoviesJson.data(using: .utf8)
                    {
                        favoriteMovies = try JSONDecoder().decode([Movie].self, from: favoritesData)
                    }
                    self.tableView.reloadData()
                } catch{print("cant decode from json file")}
                
            }
            catch {print("cant find file")}
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fav_cell", for: indexPath) as! FavoriteMovieTableViewCell
        
        
        
        cell.movieTitleLabel.text = favoriteMovies[indexPath.row].title
        cell.votesLabel.text = favoriteMovies[indexPath.row].vote_average?.toString
        cell.moviePosterImageView.layer.cornerRadius = 10.0
        cell.moviePosterImageView.clipsToBounds = true
        cell.movieTypeAndLengthLabel.adjustsFontSizeToFitWidth = true
        cell.movieTypeAndLengthLabel.text = ""
        cell.movieTypeAndLengthLabel.text = favoriteMovies[indexPath.row].genreAndDuration

        NetworkService.getMoviePoster(posterUrl: favoriteMovies[indexPath.row].poster_path!, completion: { (image) in
            cell.moviePosterImageView.image = image
        })

        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MovieDetailViewController {
            
            destination.delegate = self
            destination.selectedMovie = selectedMovie
            
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = favoriteMovies[indexPath.row]
        performSegue(withIdentifier: "showMovieDetailSegue", sender: self)
    }
    


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteMovies.count
    }


}

extension FavoriteMoviesTableViewController : MovieDetailViewControllerDelegate {
   
    
    func selectedFavoriteMovie(favorite: Movie) {
        
    }
    
    func removedFavoriteMovie(favorite: Movie) {
        
        
        for var movie in favoriteMovies {
            
            if( movie.id == favorite.id)
            {
                movie.isFavorite = false
                if let index = favoriteMovies.index(of: favorite){
                    
                    favoriteMovies.remove(at: index)
                    
                }
                
                do {
                    let favoritesData = try JSONEncoder().encode(favoriteMovies)
                    let fileName = "favs.json"
                    
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        
                        let fileURL = dir.appendingPathComponent(fileName)
                        do {
                            try favoritesData.write(to: fileURL, options: .atomic)
                        }
                        catch {print("can't find file")}
                    }
                }catch{print("can't encode data to file")}
                
                
                
                break
            }
        }
        
        
        
    }
    
    
}


