//
//  ProfileCell.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/21.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .lightGray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
}
