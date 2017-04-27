//
//  ViewController.swift
//  KamcordShots
//
//  Created by Sang Hyuk Cho on 3/27/17.
//  Copyright © 2017 sang. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ShotsViewController: UIViewController {
	
	// Custom views
	let shotsCollectionView: UICollectionView = {
		let spacing: CGFloat = 8.0
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.sectionInset = .zero
		flowLayout.minimumLineSpacing = spacing
		flowLayout.minimumInteritemSpacing = spacing
		
		flowLayout.scrollDirection = .vertical
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.register(ShotsCollectionViewCell.self, forCellWithReuseIdentifier: ShotsCollectionViewCell.identifier)
		
		let contentInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing)
		collectionView.contentInset = contentInset
		collectionView.backgroundColor = UIColor(colorLiteralRed: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
		collectionView.alwaysBounceVertical = true
		
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()
	let activityIndicatorView: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
		indicator.activityIndicatorViewStyle = .white
		indicator.hidesWhenStopped = true
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()
	
	// Static variables
	let kamcordAPI = KamcordAPI()
	let shotsViewModel = ShotsViewModel()
	
	// Dynamic variables
	var usingImageSize: ImageSize = .medium
	var numCellsInEachRow = 3
	
	var isFetchingData: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.setup()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		self.adjustNumCellsInEachRow(basedOn: newCollection)
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		self.updateCollectionViewLayout(withScreenSize: size)
	}
	
	func setup(){
		self.navigationItem.title = "Shots"
		
		self.setupViews()
		self.setupConstraints()
		
		let screenSize = UIScreen.main.bounds.size
		let traitCollection = self.view.traitCollection
		self.initiateFetchingShotsFeed()
		self.adjustNumCellsInEachRow(basedOn: traitCollection)
		self.updateCollectionViewLayout(withScreenSize: screenSize)
		self.shotsCollectionView.dataSource = self
		self.shotsCollectionView.delegate = self
	}
	func setupViews(){
		self.view.addSubview(self.shotsCollectionView)
		self.view.addSubview(self.activityIndicatorView)
	}
	func setupConstraints(){
		self.shotsCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		self.shotsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		self.shotsCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
		self.shotsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		
		self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
	}
	func initiateFetchingShotsFeed(){
		// Start fetching shots data using the Kamcord API
		self.isFetchingData = true
		self.activityIndicatorView.startAnimating()
		self.shotsViewModel.fetchShotsFeed(errorHandler: {
			// ErrorHandler
			DispatchQueue.main.async {
				self.isFetchingData = false
				self.activityIndicatorView.stopAnimating()
			}
		}) {
			// CompletionHandler
			DispatchQueue.main.async {
				self.shotsCollectionView.reloadData()
				self.isFetchingData = false
				self.activityIndicatorView.stopAnimating()
			}
		}
	}
	func adjustNumCellsInEachRow(basedOn traitCollection: UITraitCollection){
		// Determine the device(iPhone/iPad) using traits,
		// change the number of cells on each row
		switch traitCollection.horizontalSizeClass{
		case .compact, .unspecified:
			self.numCellsInEachRow = 3
		case .regular:
			self.numCellsInEachRow = 5
		}
	}
	func updateCollectionViewLayout(withScreenSize size: CGSize){
		let screenWidth = size.width
		let spacing: CGFloat = 8.0
		
		// Update the itemSize of the shotsCollectionViewCells based on the screen size.
		let cellWidth = (screenWidth - (2 * spacing + CGFloat(self.numCellsInEachRow - 1) * spacing)) / CGFloat(self.numCellsInEachRow)
		let cellHeight = (cellWidth * 16.0)/11.0
		
		if let flowLayout = self.shotsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
			flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
			flowLayout.invalidateLayout()
		}
	}
}

extension ShotsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.shotsViewModel.shots.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShotsCollectionViewCell.identifier, for: indexPath) as? ShotsCollectionViewCell
		let shot = self.shotsViewModel.shots[indexPath.row]
		
		if let thumbNailImage = shot.getThumbNail(ofImageSize: self.usingImageSize){
			cell?.setValues(image: thumbNailImage, numHearts: shot.numHearts)
		}
		
		return cell!
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// Play the video of the selected Shot in another View Controller
		let selectedShot = self.shotsViewModel.shots[indexPath.row]
		
		let playerViewController = AVPlayerViewController()
		playerViewController.player = selectedShot.avPlayer
		
		self.present(playerViewController, animated: true) {
			playerViewController.player?.play()
		}
	}
}

extension ShotsViewController{
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// Scroll down for more feed
		let threshold: CGFloat = 100.0
		let contentOffset: CGFloat = scrollView.contentOffset.y
		let maximumOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
		
		if !self.isFetchingData && (threshold < (contentOffset - maximumOffset)){
			self.initiateFetchingShotsFeed()
		}
	}
}


