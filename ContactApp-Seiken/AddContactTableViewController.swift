//
//  AddContactTableViewController.swift
//  ContactApp-Seiken
//
//  Created by Seiken Dojo on 2023-03-03.
//

import UIKit
import CoreData

class AddContactTableViewController: UITableViewController {

    //MARK: IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet var cameraTapGesture: UITapGestureRecognizer!
    
    //MARK: Vars
   
    let imagePicker = UIImagePickerController()
    var avatarImage: UIImage?
    var datePicker = UIDatePicker()
    var dateOfBirth: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configPicker()
        createDatePicker()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //MARK: Table view delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 10
        } else {
            return 0
        }
    }
    
    //MARK: IBActions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if nameTextField.text != "" && surNameTextField.text != "" && phoneNumberTextField.text != "" {
            creatNewContact()
        } else {
            //Add alert controller
            print("Please insert name, surname and phone")
        }
    }
    
    @IBAction func cameraTapped(_ sender: UITapGestureRecognizer) {
        configActionSheet()
    }
    
  
    //MARK: AlertController on Tapped gesture
    func configActionSheet() {
        let actionSheet = UIAlertController(title: "Photo", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker,animated: true) }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            self.imagePicker.sourceType = .photoLibrary
            self.`present`(self.imagePicker,animated: true) }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            actionSheet.popoverPresentationController?.sourceView = avatarImageView
            actionSheet.popoverPresentationController?.sourceRect = avatarImageView.bounds
            actionSheet.popoverPresentationController?.permittedArrowDirections = .left
        default:
            break
        }
    }

    //MARK: Saving Contact
    func creatNewContact() {
        let context = AppDelegate.context
        let newContact = Contact(context: context)
        newContact.name = nameTextField.text!
        newContact.surName = surNameTextField.text!
        newContact.phoneNumber = phoneNumberTextField.text
        newContact.fullName = newContact.name! + " " + newContact.surName!
        
        if dateOfBirth != nil {
            newContact.dateOfBirth = dateOfBirth
        }
        if addressTextView.text != nil {
            newContact.address = addressTextView.text!
        }
        if avatarImage != nil {
            newContact.avatar = avatarImage?.jpegData(compressionQuality: 0.7)
        }
        
        //TODO: how to save to core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        self.dismiss(animated: true)
    }
    
    //MARK: Helpers
    func configPicker() {
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        avatarImageView.makeRounded()
        avatarImageView.contentMode = .scaleAspectFill
    }
    
    //MARK: Configure TextField
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        dateOfBirthTextField.inputView = datePicker
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(self.datePickerChangeValue), for: .valueChanged)
    }
    
    @objc func datePickerChangeValue() {
        dateOfBirth = datePicker.date
        let dateString = dateFormatter().string(from: datePicker.date)
        dateOfBirthTextField.text = dateString
    }
}

//MARK: ImagePickerController Delegate
extension AddContactTableViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            avatarImage = image
            avatarImageView.image = avatarImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
