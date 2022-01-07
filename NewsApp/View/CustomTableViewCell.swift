//
//  CustomTableViewCell.swift
//  NewsApp
//
//  Created by Андрій Бойчук on 06.01.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet var imageURL: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var delegate: CustomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageURL.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
