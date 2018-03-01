//
//  FavoriteMoviesTableViewController.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/1/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit

class FavoriteMoviesTableViewController: UITableViewController {

    var favoriteMovies : [Movie] = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let favoritesData = UserDefaults.standard.data(forKey: "favMovies")
        {
            favoriteMovies = try! JSONDecoder().decode([Movie].self, from: favoritesData)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = favoriteMovies[indexPath.row].title
        return cell
        
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
