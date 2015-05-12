//
//  ThreadTableViewCell.swift
//  Plato
//
//  Created by Eric Conner on 4/28/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import UIKit

class DiscussionTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var discussion: Discussion? {
        didSet {
            participantsLabel.text = discussion!.getParticipantsText()
            
            // TODO: make this async
            if let url = NSURL(string: discussion!.image_url) {
                if let data = NSData(contentsOfURL: url) {
                    thumbnail.image = UIImage(data: data)
                }
            }
            
            descriptionLabel.text = discussion!.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
