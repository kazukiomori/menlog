//
//  ProfileCell.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/21.
//

import UIKit
import SDWebImage

class ProfileCell: UICollectionViewCell {
    
//    @IBOutlet weak var postImageView: UIImageView! = {
//        let iv = UIImageView()
//        iv.image = UIImage(named: "ラーメン")
//        return iv
//    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(named: "ラーメン")
        return iv
    }()
    
    var viewModel: PostViewModel? {
        didSet{ configure()}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        postImageView.setDimensions(height: 100, width: 300)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        postImageView.sd_setImage(with: viewModel.imageUrl)
    }
}
