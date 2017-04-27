//
//  MoviesTableViewCell.swift
//  iTunes25
//
//  Created by Sang Hyuk Cho on 3/19/17.
//  Copyright © 2017 sang. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

	@IBOutlet weak var movieImageView: UIImageView!
	@IBOutlet weak var movieTitleLabel: UILabel!
	@IBOutlet weak var movieReleaseDateLabel: UILabel!
	@IBOutlet weak var moviePriceLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
