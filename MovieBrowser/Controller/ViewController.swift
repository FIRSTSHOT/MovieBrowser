//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UITableViewController {

    var movies: [Movie] = []
    var selectedMovie: Movie?
    var favoriteMovies: [Movie] = []
    var defaults = UserDefaults.standard
    var moviesApi = "/3/discover/movie?api_key=98ddab1a678013f4f420946ce3d8b605&language=en-US&sort_by=popularity.desc&page=1"
    var genresApi = "/3/genre/movie/list?api_key=98ddab1a678013f4f420946ce3d8b605&language=en-US"

    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
        setFavoritesFromFileSystem()
    }

    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       setFavoritesFromFileSystem()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        cell.moviePosterImageView.layer.cornerRadius = 10.0
        cell.moviePosterImageView.clipsToBounds = true
        cell.movieTypeAndLengthLabel.adjustsFontSizeToFitWidth = true
        cell.movieTypeAndLengthLabel.text = ""
        let movie = movies[indexPath.row]
        if  let id = movie.id, let votes = movie.voteAverage,let title = movie.title,let imageUrl = movie.posterPath ,  let genres = movie.genre{
            cell.votesLabel.text = votes.toString
            cell.movieTitleLabel.text = title
            cell.posterImagePath = imageUrl
            NetworkService.getMoviePoster(posterUrl: imageUrl, completion: { (image) in
                cell.moviePosterImageView.image = image
            })
            for i in 0..<3 {
                if(genres.count > i){
                    if let cellText = cell.movieTypeAndLengthLabel.text,let name = genres[i].name {
                        if(i == 0) {cell.movieTypeAndLengthLabel.text = cellText     + name}
                        else {cell.movieTypeAndLengthLabel.text = cellText + " | " + name}
                    }
                }
            }
            NetworkService.getMovieById(movieId: id, completion: { (movie) in
                if let cellText = cell.movieTypeAndLengthLabel.text  {
                    let (h,m) = self.minutesToHours(minutes: (movie?.runtime)!)
                    cell.movieTypeAndLengthLabel.text = cellText + " - " + h.toString + "h " + m.toString + "m"
                    if let cellText = cell.movieTypeAndLengthLabel.text {
                        self.movies[indexPath.row].genreAndDuration = cellText
                    }
                }
            })
        }
        return cell
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "showMovieDetailSegue", sender: self)
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailViewController {
            destination.delegate = self
            destination.selectedMovie = selectedMovie
        }
    }
    
    func setFavoritesFromFileSystem()
    {
        let fileName = "favs.json"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                let favMoviesJson = try String(contentsOf: fileURL, encoding: .utf8)
                do{
                    if let favoritesData = favMoviesJson.data(using: .utf8) {
                        favoriteMovies = try JSONDecoder().decode([Movie].self, from: favoritesData)
                        if !movies.isEmpty {
                            for i in 0..<self.movies.count {
                                let movie = movies[i]
                                favoriteMovies.forEach({ (fav) in
                                    if(movie == fav){
                                        if let isFavorite = fav.isFavorite {
                                            movies[i].setIsFavorite(value: isFavorite)
                                        }
                                    }
                                })
                            }
                        }
                    }
                } catch{print("can't decode from json file")}
            }
            catch { print("can't find file")}
        }
    }
    
    func getMovies() {
        
        NetworkService.getAllMovies(apiUrl: moviesApi) { (data) in
            guard let movies = data else {return}
            self.movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func minutesToHours (minutes : Int) -> (Int, Int) {
        return (minutes / 60, minutes % 60)
    }

}

extension ViewController : MovieDetailViewControllerDelegate {
    
    func removedFavoriteMovie(favorite: Movie) {
        if let index = movies.index(where: { $0 == favorite}) {
            favoriteMovies.remove(at: index)
            writeFavoritesToFile(movies: favoriteMovies)
        }
    }
    
    func selectedFavoriteMovie(favorite: Movie) {
         if let index = movies.index(where: { $0 == favorite}) {
            movies[index].setIsFavorite(value: true)
            favoriteMovies.append(movies[index])
            writeFavoritesToFile(movies: favoriteMovies)
        }
    }
    
}

extension Int{
    
    var toString : String {
        return String(self)
    }
}
extension Double{
    
    var toString : String {
        return String(self)
    }
}

extension UIViewController {
    
    func writeFavoritesToFile(movies: [Movie])
    {
        do {
            let favoritesData = try JSONEncoder().encode(movies)
            let fileName = "favs.json"
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent(fileName)
                do {
                    try favoritesData.write(to: fileURL, options: .atomic)
                }
                catch {print("can't find file")}
            }
        }catch{print("can't encode data to file")}
        
    }
    
}
