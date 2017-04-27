//
//  ViewController.swift
//  MeetTheTeam
//
//  Created by Sang Hyuk Cho on 3/22/17.
//  Copyright © 2017 sang. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
	let titleStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .equalSpacing
		stackView.alignment = .leading
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Meet The Team!"
		label.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	let instructionLabel: UILabel = {
		let label = UILabel()
		label.text = "Try swiping up the name"
		label.font = UIFont(name: "HelveticaNeue", size: 17.0)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let teamCollectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.sectionInset = .zero
		flowLayout.minimumLineSpacing = 32.0
		flowLayout.minimumInteritemSpacing = 0.0
		flowLayout.scrollDirection = .horizontal
		
		let screenWidth = UIScreen.main.bounds.width
		let screenHeight = UIScreen.main.bounds.height
		let cellWidth = screenWidth * 0.7
		let cellHeight = (cellWidth * 16.0)/11.0
		flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
		
		let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight), collectionViewLayout: flowLayout)
		collectionView.register(TeamCollectionViewCell.self, forCellWithReuseIdentifier: TeamCollectionViewCell.identifier)
		
		let colViewInsetX = (screenWidth - cellWidth)/2.0
		let colViewInsetY = (screenHeight - cellHeight)/2.0
		collectionView.contentInset = UIEdgeInsets(top: colViewInsetY, left: colViewInsetX, bottom: colViewInsetY, right: colViewInsetX)
		collectionView.backgroundColor = UIColor(colorLiteralRed: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
		
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()
	
	var teamMembers: [TeamMember] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.setup()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func setup(){
		self.loadTeamData()
		
		self.teamCollectionView.dataSource = self
		self.teamCollectionView.delegate = self
		
		self.setupViews()
		self.setupConstraints()
	}
	func setupViews(){
		self.view.addSubview(self.teamCollectionView)
		
		self.titleStackView.addArrangedSubview(self.titleLabel)
		self.titleStackView.addArrangedSubview(self.instructionLabel)
		self.view.addSubview(self.titleStackView)
	}
	func setupConstraints(){
		self.titleStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.teamCollectionView.contentInset.top/2).isActive = true
		self.titleStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.teamCollectionView.contentInset.left).isActive = true
		self.titleStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -self.teamCollectionView.contentInset.right).isActive = true
		
		self.teamCollectionView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
		self.teamCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		self.teamCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
		self.teamCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
	}
	
	func loadTeamData(){
		// Load data from team.json, put it in an array of TeamMembers
		let jsonPath = Bundle.main.path(forResource: "team", ofType: "json")!
		let jsonData = try! Data(contentsOf: URL(fileURLWithPath: jsonPath))
		let json = JSON(data: jsonData)

		for (_, member) in json{
			if let avatarURL = member["avatar"].string, let bio = member["bio"].string, let firstName = member["firstName"].string, let lastName = member["lastName"].string, let title = member["title"].string, let id = member["id"].string{
				
				if let imageURL = URL(string: avatarURL), let imageData = try? Data(contentsOf: imageURL), let avatar = UIImage(data: imageData){
					let teamMember = TeamMember(id: id, title: title, firstName: firstName, lastName: lastName, bio: bio, avatar: avatar)
					self.teamMembers.append(teamMember)
				}
				
			}
		}
	}
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.teamMembers.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamCollectionViewCell.identifier, for: indexPath) as? TeamCollectionViewCell
		
		let member = self.teamMembers[indexPath.row]
		
		cell?.setValues(image: member.avatar, name: "\(member.firstName) \(member.lastName)", title: member.title, bio: member.bio)

		return cell!
	}
	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		// Un-expand cells when out of screen
		let cell = cell as? TeamCollectionViewCell
		cell?.unexpandCell()
	}
}

extension ViewController: UIScrollViewDelegate{
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		// Center cell when dragging stops
		let flowLayout = self.teamCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
		let cellWidthWithSpacing = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
		
		var scrollOffset = targetContentOffset.pointee
		var cellIndex = (scrollOffset.x + self.teamCollectionView.contentInset.left)/cellWidthWithSpacing
		cellIndex = round(cellIndex)
		
		scrollOffset = CGPoint(x: cellIndex * cellWidthWithSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
		targetContentOffset.pointee = scrollOffset
	}
}
