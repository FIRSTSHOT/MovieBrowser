//
//  FavoriteMovieTableViewCell.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/5/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit

class FavoriteMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var movieTypeAndLengthLabel: UILabel!
    var posterImagePath:String?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
