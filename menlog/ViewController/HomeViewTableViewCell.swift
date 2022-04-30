//
//  HomeViewTableViewCell.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/15.
//

import UIKit

class HomeViewTableViewCell: UITableViewCell {
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
