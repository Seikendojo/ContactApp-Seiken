//
//  ProfileViewController.swift
//  ContactApp-Seiken
//
//  Created by Seiken Dojo on 2023-03-03.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    //MARK: Vars
    var localContact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //MARK: Helpers
    func updateUI() {
        if let contact = localContact {
            title = contact.fullName
            avatarImageView.makeRounded()
            avatarImageView.contentMode = .scaleAspectFill
            if contact.avatar != nil {
                avatarImageView.image = UIImage(data: contact.avatar!)
            }
            phoneNumberLabel.text = contact.phoneNumber
            dateOfBirthLabel.text = dateFormatter().string(from: contact.dateOfBirth ?? Date())
            addressLabel.text = contact.address
        }
    }
}
