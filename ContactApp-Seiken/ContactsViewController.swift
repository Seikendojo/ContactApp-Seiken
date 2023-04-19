//
//  ContactsViewController.swift
//  ContactApp-Seiken
//
//  Created by Seiken Dojo on 2023-03-02.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController,NSFetchedResultsControllerDelegate {
 
    //MARK: Vars
    var nameTextField: UITextField!
    var surNameTextField: UITextField!
    var phoneNumberTextField: UITextField!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: AppDelegate.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("No data have been fetched!", error.localizedDescription)
        }
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //Everytime we have something inserted to core data we will insert it to tableView as well
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            print(" Unknown type")
        }
    }
}

    //MARK: TableView DataSource
    extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return fetchedResultsController.sections?[0].numberOfObjects ?? 0
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactTableViewCell
                let myContact = fetchedResultsController.object(at: indexPath)  as! Contact
                cell.setupCell(contact: myContact)
                return cell
            }
        
    //MARK: TableView Delegate
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "contactsToProfileSeg", sender: indexPath)
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
    //MARK: Delete from Core Data
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            let contactToDelete = fetchedResultsController.object(at: indexPath) as! Contact
            AppDelegate.context.delete(contactToDelete)
 
        }
        
    //MARK: Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "contactsToProfileSeg" {
                let indexPath = sender as! IndexPath
                let profileVC = segue.destination as! ProfileViewController
                let tempContact = fetchedResultsController.object(at: indexPath)  as! Contact
                profileVC.localContact = tempContact
        }
    }
}




    
