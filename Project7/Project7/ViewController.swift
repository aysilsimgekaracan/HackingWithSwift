//
//  ViewController.swift
//  Project7
//
//  Created by Ayşıl Simge Karacan on 7.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        
        let filter = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        
        let reset = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetFilter))
        reset.tintColor = UIColor.red
        // Hide reset button if user didn't filtered anything
        reset.isEnabled = false
        
        
        navigationItem.leftBarButtonItems = [filter, reset]
        
        // thats the url we try to load
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https:api.whitehouse.gov/v1/petitions.json?limit=100"
            //urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https:api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            //urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        if let url = URL(string: urlString) {
            //We create a new Data object using its contentsOf method. This returns the content from a URL, but it might throw an error (i.e., if the internet connection was down) so we need to use try?.
            if let data = try? Data(contentsOf: url) {
                //we're OK to  parse
                parse(json: data)
                return
            }
            
            showError()
        }
        
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        // An object that decodes instances of a data type from JSON objects.
        let decoder = JSONDecoder()
        
        // Asking it to convert our json data into a Petitions object.
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            // If the JSON was converted successfully, assign the results array to our petitions property then reload the table view.
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    // Challenge 1 - Add a Credits button to the top-right corner using UIBarButtonItem. When this is tapped, show an alert telling users the data comes from the We The People API of the Whitehouse.
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    //Challenge 2 - Let users filter the petitions they see. This involves creating a second array of filtered items that contains only petitions matching a string the user entered. Use a UIAlertController with a text field to let them enter that string. This is a tough one, so I’ve included some hints below if you get stuck.
    
    @objc func filterPetitions() {
        let ac = UIAlertController(title: "Filter Petitions", message: "Enter a keyword", preferredStyle: .alert)
        ac.addTextField()
        
        let filterAction = UIAlertAction(title: "Submit", style: .default) { [weak ac, self] _ in
            guard let keyword = ac?.textFields?[0].text else { return }
            self.filter(keyword)
        }
        
        ac.addAction(filterAction)
        present(ac, animated: true)
        
    }
    
    // Reset all filters
    
    @objc func resetFilter() {
        filteredPetitions.removeAll()
        tableView.reloadData()
        self.navigationItem.leftBarButtonItems?.last?.isEnabled = false
    }
    
    // check if title contains filtered words
    func filter(_ keyword: String) {
        for idx in 0...petitions.count - 1 {
            if petitions[idx].title.lowercased().contains(keyword.lowercased()){
                filteredPetitions.append(petitions[idx])
            }
        }
        
        if filteredPetitions.isEmpty {
            let ac = UIAlertController(title: "Error", message: "No match found!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        } else {
            // make reset buton visible
            self.navigationItem.leftBarButtonItems?.last?.isEnabled = true
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.isEmpty ? petitions.count : filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = "Title goes here"
//        cell.detailTextLabel?.text = "Subtitle goes here"
        
        let petition : Petition

        if filteredPetitions.isEmpty {
            petition = petitions[indexPath.row]
        } else {
            petition = filteredPetitions[indexPath.row]
        }
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

