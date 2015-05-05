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
    
    var discussion: Discussion? {
        didSet {
            participantsLabel.text = discussion!.getParticipantsText()
            
            // TODO: make this async
            thumbnail.image = UIImage(data: NSData(contentsOfURL: NSURL(string: discussion!.image_url)!)!)
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
