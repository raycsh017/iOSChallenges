//
//  KamcordAPIResult.swift
//  KamcordShots
//
//  Created by Sang Hyuk Cho on 3/29/17.
//  Copyright © 2017 sang. All rights reserved.
//

import Foundation

enum KamcordAPIResult{
	case success(String, String, [Shot])
	case failure(String)
}
