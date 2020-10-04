//
//  DetailViewController.swift
//  Milestone-Projects19-21
//
//  Created by Ayşıl Simge Karacan on 3.10.2020.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var noteTextView: UITextView!
    
    weak var delegate: TableViewDelegate?
    
    var noteSubText: String!
    var noteTitle: String!
    var index: Int!
    var backButtonTapped = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.text = "\(noteTitle ?? "")\n\(noteSubText ?? "")"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        delete.tintColor = .red
        
        toolbarItems = [spacer, delete]
        navigationController?.isToolbarHidden = false
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if backButtonTapped {
            let allNote = noteTextView.text
            if  allNote != nil {
                let newlineChars = NSCharacterSet.newlines
                var linesArray = allNote!.components(separatedBy: newlineChars).filter{!$0.isEmpty}
                
                guard !linesArray.isEmpty else { return }
                
                if !linesArray[0].isEmpty{
                    noteTitle = linesArray[0]
                    linesArray.removeFirst()
                } else {
                    noteTitle = "New Note"
                }
                
                if linesArray.joined() != "" {
                    noteSubText = linesArray.joined()
                } else {
                    noteSubText = ""
                }
                
                delegate?.saveNote(index: index, noteTitle: noteTitle, noteSubText: noteSubText)
            }
        }
        
    }
    
    @objc func shareButtonTapped() {
        guard let note = noteTextView.text else { return }
        
        let vc = UIActivityViewController(activityItems: [note], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
    @objc func deleteNote() {
        backButtonTapped = false
        delegate?.deleteNote(index: index)
        navigationController?.popToRootViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
