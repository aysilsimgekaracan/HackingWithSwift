//
//  ViewController.swift
//  Milestone-Project4-6
//
//  Created by Ayşıl Simge Karacan on 7.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        // Clear Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        
        // Share Button
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        // used for align the share button to left
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
       
        toolbarItems = [flexible, share]
        navigationController?.isToolbarHidden = false
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let addItemAction = UIAlertAction(title: "Add", style: .default) { [weak ac, self] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self.shoppingList.insert(item, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        ac.addAction(addItemAction)
        present(ac, animated: true)
    }
    
    @objc func clearList() {
        shoppingList.removeAll()
        tableView.reloadData()
    }
    
    @objc func shareTapped() {
        let list = shoppingList.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }


}
