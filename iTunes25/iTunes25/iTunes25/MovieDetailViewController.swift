//
//  MovieDetailViewController.swift
//  iTunes25
//
//  Created by Sang Hyuk Cho on 3/19/17.
//  Copyright © 2017 sang. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

	@IBOutlet weak var movieImageView: UIImageView!
	@IBOutlet weak var movieTitleLabel: UILabel!
	@IBOutlet weak var moviePriceLabel: UILabel!
	@IBOutlet weak var movieReleaseDateLabel: UILabel!
	
	var selectedMovie: Movie?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		if let selectedMovie = self.selectedMovie{
			let movieImageData = try! Data(contentsOf: URL(string: selectedMovie.imageURL)!)
			self.movieImageView.image = UIImage(data: movieImageData)
			self.movieTitleLabel.text = "Title: \(selectedMovie.title)"
			self.moviePriceLabel.text = "Price: \(selectedMovie.price)"
			self.movieReleaseDateLabel.text = "Release Date: \(selectedMovie.releaseDate)"
		}
    }

	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func openInITunes(_ sender: Any) {
		if let selectedMovie = self.selectedMovie{
			let movieLinkToITunes = URL(string: selectedMovie.iTunesURL)
			if UIApplication.shared.canOpenURL(movieLinkToITunes!){
				UIApplication.shared.open(movieLinkToITunes!, options: [:], completionHandler: nil)
			}
		}
	}
}
