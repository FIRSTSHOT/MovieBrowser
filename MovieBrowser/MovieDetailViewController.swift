//
//  MovieDetailViewController.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.


import UIKit

protocol MovieDetailViewControllerDelegate {
    func selectedFavoriteMovie(favorite : Movie)
}

class MovieDetailViewController: UIViewController {
    

    @IBOutlet weak var addToFavoritesButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    var isFavorite:Bool?
    
    var selectedMovie:Movie?
    var delegate : MovieDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(selectedMovie != nil)
        {
            titleLabel.text = selectedMovie?.title
            overviewTextView.text = selectedMovie?.overview
            
            if(isFavorite != nil)
            {
                addToFavoritesButton.setTitle("Movie Added", for: .normal)
                addToFavoritesButton.isEnabled = false
                
            }
        }
        
        
    }

    @IBAction func AddToFavorites(_ sender: Any) {
        
        if let movie = selectedMovie {
         
            delegate?.selectedFavoriteMovie(favorite: movie)
            
            addToFavoritesButton.setTitle("Movie Added", for: .normal) 
            addToFavoritesButton.isEnabled = false
            
            
        }
        
        
        
        
    }
    
}

