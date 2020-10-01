//
//  TableViewController.swift
//  Extension
//
//  Created by Ayşıl Simge Karacan on 1.10.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var scripts = [Scripts]()
    weak var delegate: ActionViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "scriptCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scripts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scriptCell", for: indexPath)
        cell.textLabel?.text = scripts[indexPath.row].name ?? "script name couldn't loaded."
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var script = scripts[indexPath.row]
        let ac = UIAlertController(title: "URL: \(String(describing: script.url!))", message: "\(String(describing: script.script!))", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Change the Scripts Name", style: .default, handler: { [weak self] _ in
            
            let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
            ac.addTextField(configurationHandler: nil)
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
                
                guard let newValue = ac?.textFields?[0].text else { return }
                script.name = newValue
                self?.delegate?.renameScript(newName: newValue, idx: indexPath)
                self?.refresh()
            }
            ac.addAction(submitAction)
            self?.present(ac, animated: true, completion: nil)
            
        }))
        
        ac.addAction(UIAlertAction(title: "Load the Script", style: .default, handler: { [weak self] _ in
            self?.delegate?.loadScript(fromScript: script.script)
            self?.navigationController?.popViewController(animated: true)
            
        }))
        
        ac.addAction(UIAlertAction(title: "Delete the Script", style: .default, handler: { [weak self] _ in
            self?.delegate?.deleteScript(idx: indexPath)
            self?.refresh()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true, completion: nil)
        
    }
    
    func refresh() {
        scripts = delegate?.getScripts() ?? scripts as! [Scripts]
        tableView.reloadData()
    }


}
