//
//  ViewController.swift
//  CoreDataProject
//
//  Created by monitora on 21/08/19.
//  Copyright © 2019 Haroldo Leite. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var addNameButton: UIBarButtonItem! {
        didSet {
            self.addNameButton.target = self
            self.addNameButton.action = #selector(self.addNameAction)
        }
    }
    
    // MARK: Variables
    var names: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Task list"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @objc func addNameAction() {
        let alert = UIAlertController(title: "New Task", message: "Add a new Task", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let textField = alert.textFields?.first, let taskToSave = textField.text else {
                return
            }
            
            self.names.append(taskToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}

