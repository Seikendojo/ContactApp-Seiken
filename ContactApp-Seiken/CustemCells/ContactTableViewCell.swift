//
//  ContactTableViewCell.swift
//  ContactApp-Seiken
//
//  Created by Seiken Dojo on 2023-03-04.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(contact: Contact) {
        fullNameLabel.text = contact.fullName
        phoneNumberLabel.text = contact.phoneNumber
        
        if contact.avatar != nil {
            avatarImageView.image = UIImage(data: contact.avatar!)
            avatarImageView.makeRounded()
            avatarImageView.contentMode = .scaleAspectFill
        }
    }
}
