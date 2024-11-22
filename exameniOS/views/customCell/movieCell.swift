//
//  movieCell.swift
//  exameniOsVictorGarcia
//
//  Created by Victor Garcia on 21/11/24.
//

import UIKit

class movieCell: UITableViewCell {
    
    @IBOutlet weak var movieTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
