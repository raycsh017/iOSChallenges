//
//  Shot.swift
//  KamcordShots
//
//  Created by Sang Hyuk Cho on 3/28/17.
//  Copyright © 2017 sang. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Shot{
	let thumbNailURLStrings: [String: String]
	let videoURLString: String
	let numHearts: Int
	
	var imageCache: [String: UIImage?] = [:]
	var avPlayer: AVPlayer?{
		if let videoURL = URL(string: videoURLString){
			return AVPlayer(url: videoURL)
		}
		else{
			return nil
		}
	}
	
	init(thumbNailURLStrings: [String: String], videoURLString: String, numHearts: Int) {
		self.thumbNailURLStrings = thumbNailURLStrings
		self.videoURLString = videoURLString
		self.numHearts = numHearts
	}
	
	// Fetch thumbnail best for the given screen size
	func getThumbNail(ofImageSize size: ImageSize)->UIImage?{
		if let image = self.imageCache[size.string]{
			return image
		}
		if let urlString = thumbNailURLStrings[size.string], let imageURL = URL(string: urlString), let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData){
			imageCache[size.string] = image
			return image
		}
		else{
			return nil
		}
	}
}
