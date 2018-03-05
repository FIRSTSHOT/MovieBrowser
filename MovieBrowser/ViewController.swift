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

    var movies : [Movie] = []
    
    var selectedMovie: Movie?
    var favoriteMovies : [Movie] = []
    var defaults = UserDefaults.standard

    
    var moviesApi = "/3/discover/movie?api_key=98ddab1a678013f4f420946ce3d8b605&language=en-US&sort_by=popularity.desc&page=1"
    var genresApi = "/3/genre/movie/list?api_key=98ddab1a678013f4f420946ce3d8b605&language=en-US"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
    

       
        
        if let favoritesData = UserDefaults.standard.data(forKey: "favMovies")
        {
            favoriteMovies = try! JSONDecoder().decode([Movie].self, from: favoritesData)
        }
        
        getMovies { (data) in
            
            self.movies = data
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(true)
        
        self.tableView.reloadData()
    }
    
    func getMovies(completion: @escaping ([Movie]) -> Void) {
        
        NetworkService.getAllMovies(apiUrl: moviesApi) { (data) in
            
            guard let movies = data else {
                return
            }
            
            
            NetworkService.getAllMovieGenres(apiUrl: self.genresApi, completion: { (data) in
                
                
                
                
                guard let genres = data else {
                    return
                }
                
                for movie in movies {
                    
                    if let movieGenreIds = movie.genre_ids {
                        
                         movie.genre = []
                        
                        for genreId in movieGenreIds {
  
                            genres.contains(where: { (genre) -> Bool in
                                if(genre.id == genreId)
                                {
                                    movie.genre?.append(genre)
                                    return true
                                }
                                return false
                            })
                            
                        }
                    }
                    
                    
                }
                
                completion(movies)
                
               
                
            })
            
            

        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailViewController {
            
            
            destination.delegate = self
            destination.selectedMovie = selectedMovie
            
            
        }
    }


}

extension ViewController : MovieDetailViewControllerDelegate {
    
    
    func selectedFavoriteMovie(favorite: Movie) {
        
        if(!favoriteMovies.contains(where: { (m) -> Bool in
         
            if(m.id == favorite.id){
                return true
            }
            
            return false
            
        })){
            favoriteMovies.append(favorite)
        }
        
        
       let favoritesData = try! JSONEncoder().encode(favoriteMovies)
        UserDefaults.standard.set(favoritesData, forKey: "favMovies")
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell


        if let title = movies[indexPath.row].title,let votes = movies[indexPath.row].vote_average,let imageUrl = movies[indexPath.row].poster_path , let genres = movies[indexPath.row].genre,let id = movies[indexPath.row].id{
            cell.movieTitleLabel.text = title
            cell.votesLabel.text = votes.toString
            cell.posterImagePath = imageUrl
            cell.moviePosterImageView.layer.cornerRadius = 10.0
            cell.moviePosterImageView.clipsToBounds = true
            cell.movieTypeAndLengthLabel.adjustsFontSizeToFitWidth = true
             cell.movieTypeAndLengthLabel.text = ""
            
            NetworkService.getMoviePoster(posterUrl: imageUrl, completion: { (image) in
                cell.moviePosterImageView.image = image
            })
            
            for i in 0..<3 {
                
                if(genres.count > i){
                    
                    if let cellText = cell.movieTypeAndLengthLabel.text , let name = genres[i].name {
                        if(i == 0) {cell.movieTypeAndLengthLabel.text = cellText     + name}
                        else {cell.movieTypeAndLengthLabel.text = cellText + " | " + name}
                    }
                }
               

            }
            
            NetworkService.getMovieById(movieId: id, completion: { (movie) in
                if let cellText = cell.movieTypeAndLengthLabel.text  {
                    
                    let (h,m) = self.minutesToHours(minutes: (movie?.runtime)!)
                    
                    cell.movieTypeAndLengthLabel.text = cellText + " - " + h.toString + "h " + m.toString + "m"
                    
                    
                    
                    
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
    func minutesToHours (minutes : Int) -> (Int, Int) {
        return (minutes / 60, minutes % 60)
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
