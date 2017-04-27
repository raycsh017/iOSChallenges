//
//  ShotsCollectionViewCell.swift
//  KamcordShots
//
//  Created by Sang Hyuk Cho on 3/27/17.
//  Copyright © 2017 sang. All rights reserved.
//

import UIKit

class ShotsCollectionViewCell: UICollectionViewCell {
    static let identifier = "shotsCollectionViewCell"
	
	let thumbNailImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	let heartImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "ic_heart")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	let numHeartsLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.textAlignment = .center
		label.font = UIFont(name: "HelveticaNeue", size: 7.0)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	func setup(){
		self.setupViews()
		self.setupConstraints()
	}
	func setupViews(){
		self.contentView.addSubview(self.thumbNailImageView)
		self.contentView.addSubview(self.heartImageView)
		self.heartImageView.addSubview(self.numHeartsLabel)
	}
	func setupConstraints(){
		self.thumbNailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
		self.thumbNailImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
		self.thumbNailImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
		self.thumbNailImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
		
		self.heartImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8.0).isActive = true
		self.heartImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0).isActive = true
		self.heartImageView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
		self.heartImageView.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
		
		self.numHeartsLabel.centerXAnchor.constraint(equalTo: self.heartImageView.centerXAnchor).isActive = true
		self.numHeartsLabel.centerYAnchor.constraint(equalTo: self.heartImageView.centerYAnchor).isActive = true
	}
	
	func setValues(image: UIImage, numHearts: Int){
		self.thumbNailImageView.image = image
		self.numHeartsLabel.text = String(numHearts)
	}
}
