//
//  TableViewController.swift
//  Project4
//
//  Created by Ayşıl Simge Karacan on 2.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    //let websites = ["apple.com", "hackingwithswift.com"]
    var websites = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Simple Browser"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Bonus Challenge after completing project 5 - load the list of websites from a file
        
        if let websitesURL = Bundle.main.url(forResource: "websites", withExtension: "txt") {
            if let AllWebsites = try? String(contentsOf: websitesURL) {
                websites = AllWebsites.components(separatedBy: "\n")
            }
        }
        
        if websites.isEmpty {
            websites = ["apple.com", "hackingwithswift.com"]
        }
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Browser") as? ViewController {
            vc.websites = websites
            vc.selectedWebsite = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
 

}
