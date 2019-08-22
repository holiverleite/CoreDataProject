//
//  ViewController.swift
//  CoreDataProject
//
//  Created by monitora on 21/08/19.
//  Copyright © 2019 Haroldo Leite. All rights reserved.
//

import UIKit
import CoreData

enum StringConstants: String {
    case Title = "Tasks list"
    case CellIdentifier = "Cell"
    case AlertTitle = "New Task"
    case AlertMessage = "Add a new Task"
    case SaveButton = "Save"
    case CancelButton = "Cancel"
    case EntityName = "Task"
    case AttributeName = "taskDescription"
}

class ViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: StringConstants.CellIdentifier.rawValue)
        }
    }
    
    @IBOutlet weak var addNameButton: UIBarButtonItem! {
        didSet {
            self.addNameButton.target = self
            self.addNameButton.action = #selector(self.addNameAction)
        }
    }
    
    // MARK: Variables
    var tasks: [NSManagedObject] = []
    var managedContext: NSManagedObjectContext? = nil
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = StringConstants.Title.rawValue
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadTasks()
    }
    
    @objc func addNameAction() {
        let alert = UIAlertController(title: StringConstants.AlertTitle.rawValue, message: StringConstants.AlertMessage.rawValue, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: StringConstants.SaveButton.rawValue, style: .default) { (action) in
            guard let textField = alert.textFields?.first, let taskToSave = textField.text else {
                return
            }
            
            self.save(taskDescription: taskToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: StringConstants.CancelButton.rawValue, style: .cancel)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func save(taskDescription: String) {
        if let context = self.managedContext {
            let entity = NSEntityDescription.entity(forEntityName: StringConstants.EntityName.rawValue, in: context)!
            
            let task = NSManagedObject(entity: entity, insertInto: context)
            
            task.setValue(taskDescription, forKey: StringConstants.AttributeName.rawValue)
            
            do {
                try context.save()
                self.tasks.append(task)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func reloadTasks() {
        if let context = self.managedContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: StringConstants.EntityName.rawValue)
            
            do {
                self.tasks = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could no fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func removeFromDataBase(_ object: NSManagedObject, _ indexPath: IndexPath) {
        if let context = self.managedContext {
            do {
                try context.delete(object)
                self.tasks.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = self.tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.CellIdentifier.rawValue, for: indexPath)
        
        cell.textLabel?.text = task.value(forKeyPath: StringConstants.AttributeName.rawValue) as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskObject = self.tasks[indexPath.row]

            self.removeFromDataBase(taskObject, indexPath)
        }
    }
}

