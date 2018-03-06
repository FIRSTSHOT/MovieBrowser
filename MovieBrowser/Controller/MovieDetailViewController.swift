//
//  MovieDetailViewController.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit

protocol MovieDetailViewControllerDelegate {
    func selectedFavoriteMovie(favorite : Movie)
    func removedFavoriteMovie(favorite: Movie)
}

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var genreAndDurationLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    var selectedMovie: Movie?
    var delegate : MovieDetailViewControllerDelegate?
    
    override func viewDidLayoutSubviews() {
        overviewTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterImageView.layer.cornerRadius = 10.0
        posterImageView.clipsToBounds = true
        guard let selectedMovie = selectedMovie else {return}
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "star"), style: .plain, target: self, action: #selector(addToFavorites))
        navigationItem.title = selectedMovie.title
        titleLabel.text = selectedMovie.title
        overviewTextView.text = selectedMovie.overview
        votesLabel.text = selectedMovie.voteAverage?.toString
        genreAndDurationLabel.text = selectedMovie.genreAndDuration
        if let posterUrl = selectedMovie.posterPath, let releaseDate =  selectedMovie.releaseDate, let isFavorite = selectedMovie.isFavorite {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: releaseDate) else {return}
            if(isFavorite)
            {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "star_filled"), style: .plain, target: self, action: #selector(removeFromFavorite))
            }
            releaseDateLabel.text  = date.toCustomFormat()
            NetworkService.getMoviePoster(posterUrl: posterUrl, completion: { (poster) in
                self.posterImageView.image = poster
                
            })
        }
    }
    
    @objc func removeFromFavorite()
    {
        if var movie = selectedMovie {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "star"), style: .plain, target: self, action: #selector(addToFavorites))
            movie.setIsFavorite(value: false)
            delegate?.removedFavoriteMovie(favorite: movie)
        }
    }

    @objc func addToFavorites()
    {
        if var movie = selectedMovie {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "star_filled"), style: .plain, target: self, action: #selector(removeFromFavorite))
            movie.setIsFavorite(value: true)
            delegate?.selectedFavoriteMovie(favorite: movie)
        }
    }

}

extension Date {
    func toCustomFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        let date = dateFormatter.string(from: self)
        return date
    }
    
}

