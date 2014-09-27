//
//  MovieCell.swift
//  rotten
//
//  Created by Hing Huynh on 9/26/14.
//  Copyright (c) 2014 Hing Huynh. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {


    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
