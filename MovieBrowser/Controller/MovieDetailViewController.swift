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
    
    var selectedMovie:Movie?
    var delegate : MovieDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
  
        posterImageView.layer.cornerRadius = 10.0
        posterImageView.clipsToBounds = true

        
        if(selectedMovie != nil)
        {
            
             navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "star"), style: .plain, target: self, action: #selector(addToFavorites))
            
            
            navigationItem.title = selectedMovie?.title
            
            titleLabel.text = selectedMovie?.title
            overviewTextView.text = selectedMovie?.overview
            votesLabel.text = selectedMovie?.vote_average?.toString
            genreAndDurationLabel.text = selectedMovie?.genreAndDuration
            

            
            if let posterUrl = selectedMovie?.poster_path, let releaseDate =  selectedMovie?.release_date, let isFavorite = selectedMovie?.isFavorite {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                guard let date = dateFormatter.date(from: releaseDate) else {
                    return
                    
                }
                
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
    }
    
    @objc func removeFromFavorite()
    {
        if let movie = selectedMovie {
            
            print("start filled")
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "star"), style: .plain, target: self, action: nil)
            delegate?.removedFavoriteMovie(favorite: movie)
            
            
        }
        
    }
    
    
    @objc func addToFavorites() {
        
        if let movie = selectedMovie {
            
                print("start ")
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "star_filled"), style: .plain, target: self, action: nil)
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

extension UIImageView {
    func roundCornersForAspectFit(radius: CGFloat)
    {
        if let image = self.image {
            
            //calculate drawingRect
            let boundsScale = self.bounds.size.width / self.bounds.size.height
            let imageScale = image.size.width / image.size.height
            
            var drawingRect : CGRect = self.bounds
            
            if boundsScale > imageScale {
                drawingRect.size.width =  drawingRect.size.height * imageScale
                drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
            }else {
                drawingRect.size.height = drawingRect.size.width / imageScale
                drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
            }
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
