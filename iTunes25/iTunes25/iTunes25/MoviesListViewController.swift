//
//  ViewController.swift
//  iTunes25
//
//  Created by Sang Hyuk Cho on 3/19/17.
//  Copyright © 2017 sang. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var moviesTableView: UITableView!
	
	let apiURL = URL(string: "https://itunes.apple.com/us/rss/topmovies/limit=25/json")!
	
	var movies: [Movie] = []
	var selectedMovie: Movie?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.moviesTableView.dataSource = self
		self.moviesTableView.delegate = self
		self.fetchDataFromITunes()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func fetchDataFromITunes(){
		
		let session = URLSession(configuration: URLSessionConfiguration.default)
		
		let dataTask = session.dataTask(with: apiURL) { (data, response, error) in
			if let data = data{
				let jsonData = JSON(data: data)
				for(_, feed) in jsonData{
					let entries = feed["entry"]
					for (_, entry) in entries{
						let title = entry["title"]["label"].string
						let releaseDate = entry["im:releaseDate"]["attributes"]["label"].string
						let price = entry["im:price"]["label"].string
						let imageURL = entry["im:image"][2]["label"].string
						let iTunesURL = entry["link"][0]["attributes"]["href"].string
						if let title = title, let releaseDate = releaseDate,let price = price, let imageURL = imageURL, let iTunesURL = iTunesURL{
							let movie = Movie(title: title, releaseDate: releaseDate, price: price, imageURL: imageURL, iTunesURL: iTunesURL)
							self.movies.append(movie)
						}
					}
				}
				DispatchQueue.main.async {
					self.moviesTableView.reloadData()
				}
			}
		}
		dataTask.resume()
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.movies.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell") as? MoviesTableViewCell
		
		let movie = self.movies[indexPath.row]
		let movieImageURL = URL(string: movie.imageURL)
		let movieImageData = try! Data(contentsOf: movieImageURL!)
		
		cell?.movieImageView.image = UIImage(data: movieImageData)
		cell?.movieTitleLabel.text = movie.title
		cell?.movieReleaseDateLabel.text = movie.releaseDate
		cell?.moviePriceLabel.text = movie.price
		
		return cell!
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.selectedMovie = self.movies[indexPath.row]
		self.performSegue(withIdentifier: "movieDetailSegue", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let selectedMovie = self.selectedMovie{
			let destVC = segue.destination as? MovieDetailViewController
			destVC?.selectedMovie = selectedMovie
		}
	}
}

