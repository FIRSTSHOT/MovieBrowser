//
//  MovieDetailViewController.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit



class MovieDetailViewController: UIViewController {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    var selectedMovie:Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(selectedMovie != nil)
        {
            titleLabel.text = selectedMovie?.title
            overviewTextView.text = selectedMovie?.overview
        }
    }


}

