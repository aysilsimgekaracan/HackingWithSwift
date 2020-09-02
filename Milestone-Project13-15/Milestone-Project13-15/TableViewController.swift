//
//  ViewController.swift
//  Milestone-Project13-15
//
//  Created by Ayşıl Simge Karacan on 2.09.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var countries = [Countries]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    
    func fetchData() {
        let urlString = "https://restcountries.eu/rest/v2/all"

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
    }
    
    func parse(json: Data) {
        do
        {
            let jsonCountries = try JSONDecoder().decode([Countries].self, from: json)
            countries = jsonCountries
            
        }
        catch let error{
            print("Json Parse Error : \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.countryDetail = countries[indexPath.row]
    
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.isEmpty ? 0 : countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        
        return cell
    }

    
}

