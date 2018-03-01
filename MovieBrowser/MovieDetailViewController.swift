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
}

class MovieDetailViewController: UIViewController {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    
    var selectedMovie:Movie?
    var delegate : MovieDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToFavorites))
        
        if(selectedMovie != nil)
        {
            titleLabel.text = selectedMovie?.title
            overviewTextView.text = selectedMovie?.overview
            
        }
    }
    
    @objc func addToFavorites() {
        
        if let movie = selectedMovie {
            
            delegate?.selectedFavoriteMovie(favorite: movie)
            
        }
    }

    
}

