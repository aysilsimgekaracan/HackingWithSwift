//
//  ViewController.swift
//  Milestone-Projects19-21
//
//  Created by Ayşıl Simge Karacan on 3.10.2020.
//

import UIKit

protocol TableViewDelegate: class {
    func saveNote(index: Int, noteTitle: String, noteSubText: String)
    func deleteNote(index: Int)
}

class TableViewController: UITableViewController {
    var notes = [Notes]() {
        didSet {
            tableView.reloadData()
            save()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))

        // Load Notes
        let defaults = UserDefaults.standard
                     
        if let savedNotes = defaults.object(forKey: "Notes") as? Data {
            let jsonDecoder = JSONDecoder()
         
            do {
                notes = try jsonDecoder.decode([Notes].self, from: savedNotes)
            } catch {
                print("Failed to load notes.")
            }
        }
    }
    
    @objc func addNote() { // When new note is added open the detail view controller like the note app
        let newNote = Notes(title: "New Note", subText: "")
        notes.insert(newNote, at: 0)

        let detailView = storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        detailView.index = 0
        detailView.delegate = self
        detailView.backButtonTapped = true
        
        navigationController?.pushViewController(detailView, animated: true)
    }
                
    func save() {
        let jsonEncoder = JSONEncoder()
                
        if let savedNotes = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedNotes, forKey: "Notes")
        } else {
            print("Failed to save new script.")
        }
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoteCell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        let note = notes[indexPath.row]
        
        cell.cellTitleLabel.text = note.title
        cell.cellTitleLabel.sizeToFit()
        cell.cellSubtitleLabel.text = note.subText
        cell.cellSubtitleLabel.sizeToFit()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        
        let detailView = storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        detailView.index = 0
        detailView.delegate = self
        
        detailView.index = indexPath.row
        detailView.noteTitle = note.title
        detailView.noteSubText = note.subText
        detailView.backButtonTapped = true
        
        navigationController?.pushViewController(detailView, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
        }
    }
}


// MARK: - Table View Delegate
extension TableViewController : TableViewDelegate {
    func deleteNote(index: Int) {
        notes.remove(at: index)
    }
    
    func saveNote(index: Int, noteTitle: String, noteSubText: String) {
        notes[index] = Notes(title: noteTitle, subText: noteSubText)
        tableView.reloadData()
        save()
    }
}

