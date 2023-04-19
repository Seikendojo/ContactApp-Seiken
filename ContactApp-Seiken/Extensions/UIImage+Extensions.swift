//
//  UIImage+Extensions.swift
//  ContactApp-Seiken
//
//  Created by Seiken Dojo on 2023-03-05.
//

import Foundation
import UIKit

extension UIImageView {
    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
