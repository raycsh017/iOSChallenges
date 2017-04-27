//
//  TeamCollectionViewCell.swift
//  MeetTheTeam
//
//  Created by Sang Hyuk Cho on 3/22/17.
//  Copyright © 2017 sang. All rights reserved.
//

import UIKit

class TeamCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "teamCell"
	
	let avatarImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	let profileBackgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	let profileStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .equalSpacing
		stackView.alignment = .leading
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	let nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
		label.textColor = .black
		label.numberOfLines = 1
		label.lineBreakMode = .byTruncatingTail
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "HelveticaNeue", size: 17.0)
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	let scrollContainerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	let bioScrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()
	let bioLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "HelveticaNeue", size: 14.0)
		label.textColor = .black
		label.numberOfLines = 2
		label.lineBreakMode = .byTruncatingTail
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	var expanded: Bool = false
	var expandedLayout: NSLayoutConstraint!
	var nonExpandedLayout: NSLayoutConstraint!
	
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
		self.setupGestures()
		layoutIfNeeded()
		self.addMaskLayer()
	}
	func setupViews(){
		self.contentView.backgroundColor = .white
		self.contentView.layer.cornerRadius = 5.0
		self.contentView.clipsToBounds = true
		
		self.contentView.addSubview(self.avatarImageView)
		
		self.profileStackView.addArrangedSubview(self.nameLabel)
		self.profileStackView.addArrangedSubview(self.titleLabel)
		self.profileBackgroundView.addSubview(self.profileStackView)
		
		self.bioScrollView.addSubview(self.bioLabel)
		self.scrollContainerView.addSubview(self.bioScrollView)
		self.profileBackgroundView.addSubview(self.scrollContainerView)
		
		self.contentView.addSubview(self.profileBackgroundView)
	}
	func setupConstraints(){
		self.avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
		self.avatarImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
		self.avatarImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
		self.avatarImageView.heightAnchor.constraint(equalTo: self.avatarImageView.widthAnchor).isActive = true
	
		self.expandedLayout = self.profileBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
		self.nonExpandedLayout = self.profileBackgroundView.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor)
		
		self.expandedLayout.isActive = false
		self.nonExpandedLayout.isActive = true
		self.profileBackgroundView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
		self.profileBackgroundView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
		self.profileBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
		
		self.profileStackView.topAnchor.constraint(equalTo: self.profileBackgroundView.topAnchor, constant: 6.0).isActive = true
		self.profileStackView.leftAnchor.constraint(equalTo: self.profileBackgroundView.leftAnchor, constant: 16.0).isActive = true
		self.profileStackView.rightAnchor.constraint(equalTo: self.profileBackgroundView.rightAnchor, constant: -16.0).isActive = true
		
		self.scrollContainerView.topAnchor.constraint(equalTo: self.profileStackView.bottomAnchor, constant: 8.0).isActive = true
		self.scrollContainerView.leftAnchor.constraint(equalTo: self.profileBackgroundView.leftAnchor, constant: 16.0).isActive = true
		self.scrollContainerView.rightAnchor.constraint(equalTo: self.profileBackgroundView.rightAnchor, constant: -16.0).isActive = true
		self.scrollContainerView.bottomAnchor.constraint(equalTo: self.profileBackgroundView.bottomAnchor, constant: -8.0).isActive = true
		
		self.bioScrollView.topAnchor.constraint(equalTo: self.scrollContainerView.topAnchor).isActive = true
		self.bioScrollView.leftAnchor.constraint(equalTo: self.scrollContainerView.leftAnchor).isActive = true
		self.bioScrollView.rightAnchor.constraint(equalTo: self.scrollContainerView.rightAnchor).isActive = true
		self.bioScrollView.bottomAnchor.constraint(equalTo: self.scrollContainerView.bottomAnchor).isActive = true
		
		self.bioLabel.widthAnchor.constraint(equalTo: self.scrollContainerView.widthAnchor).isActive = true
		self.bioLabel.topAnchor.constraint(equalTo: self.bioScrollView.topAnchor).isActive = true
		self.bioLabel.leftAnchor.constraint(equalTo: self.bioScrollView.leftAnchor).isActive = true
		self.bioLabel.rightAnchor.constraint(equalTo: self.bioScrollView.rightAnchor).isActive = true
		self.bioLabel.bottomAnchor.constraint(equalTo: self.bioScrollView.bottomAnchor).isActive = true
	}
	func setupGestures(){
		let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGestureOnProfile(_:)))
		self.profileBackgroundView.addGestureRecognizer(gestureRecognizer)
	}
	func handlePanGestureOnProfile(_ gestureRecognizer: UIPanGestureRecognizer){
		let yOffset = gestureRecognizer.translation(in: self.contentView).y
		if yOffset < -50.0 && !expanded{
			self.expandCell()
		}
		else if yOffset > 50.0 && expanded{
			self.unexpandCell()
		}
	}
	func expandCell(){
		self.expanded = true
		self.expandedLayout.isActive = true
		self.nonExpandedLayout.isActive = false
		UIView.animate(withDuration: 0.3, animations: {
			self.layoutIfNeeded()
			self.nameLabel.numberOfLines = 0
			self.nameLabel.lineBreakMode = .byWordWrapping
			self.bioLabel.numberOfLines = 0
			self.bioLabel.lineBreakMode = .byWordWrapping
		})
	}
	func unexpandCell(){
		self.expanded = false
		self.expandedLayout.isActive = false
		self.nonExpandedLayout.isActive = true
		UIView.animate(withDuration: 0.3, animations: {
			self.layoutIfNeeded()
			self.nameLabel.numberOfLines = 1
			self.nameLabel.lineBreakMode = .byTruncatingTail
			self.bioLabel.numberOfLines = 2
			self.bioLabel.lineBreakMode = .byTruncatingTail
		})
	}
	
	func addMaskLayer(){
		// Add cut-away effect to image
		let maskLayer = CAShapeLayer()
		maskLayer.fillColor = UIColor.white.cgColor
		
		let path = UIBezierPath()
		let origin = self.avatarImageView.frame.origin
		let size = self.avatarImageView.frame.size
		
		path.move(to: CGPoint(x: origin.x, y: origin.y))
		path.addLine(to: CGPoint(x: origin.x + size.width, y: origin.y))
		path.addLine(to: CGPoint(x: origin.x + size.width, y: origin.y + size.height))
		path.addLine(to: CGPoint(x: origin.x, y: origin.y + size.height - 50.0))
		maskLayer.path = path.cgPath
		
		self.avatarImageView.layer.mask = maskLayer
	}
	
	func setValues(image: UIImage, name: String, title: String, bio: String){
		self.avatarImageView.image = image
		self.nameLabel.text = name
		self.titleLabel.text = title
		self.bioLabel.text = bio
	}
}
