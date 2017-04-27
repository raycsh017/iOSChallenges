//
//  ImageSize.swift
//  KamcordShots
//
//  Created by Sang Hyuk Cho on 3/29/17.
//  Copyright © 2017 sang. All rights reserved.
//

import Foundation

enum ImageSize{
	case small
	case medium
	case large
	
	var string: String{
		switch self{
		case .small:
			return "small"
		case .medium:
			return "medium"
		case .large:
			return "large"
		}
	}
}
