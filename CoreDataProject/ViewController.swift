//
//  ViewController.swift
//  CoreDataProject
//
//  Created by monitora on 21/08/19.
//  Copyright © 2019 Haroldo Leite. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    
    @IBAction func addName(_ sender: Any) {
        
    }
    
    var names: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "The list"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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

