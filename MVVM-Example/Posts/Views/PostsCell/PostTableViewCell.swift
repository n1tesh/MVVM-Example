//
//  PostTableViewCell.swift
//  MVVM-Example
//
//  Created by Nitesh on 22/03/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    static let cellIdentifier = "PostCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    var post: Post!{
        didSet{
            self.titleLabel.text = post.title
            self.bodyLabel.text = post.body
            self.userLabel.text = "UserId: \(post.userId)"

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
