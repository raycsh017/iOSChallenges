//
//  StringExtension.swift
//  MeetTheTeam
//
//  Created by Sang Hyuk Cho on 3/23/17.
//  Copyright © 2017 sang. All rights reserved.
//

import Foundation
import UIKit

extension String{
	func getEstimatedHeight(with width: CGFloat, font: UIFont) -> CGFloat{
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
		
		return ceil(boundingBox.height)
	}
}
