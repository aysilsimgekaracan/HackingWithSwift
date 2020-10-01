//
//  ActionViewController.swift
//  Extension
//
//  Created by Ayşıl Simge Karacan on 18.09.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol ActionViewControllerDelegate: class {
    func loadScript(fromScript loadedScript: String)
    func deleteScript(idx scriptIndex: IndexPath)
    func renameScript(newName name: String, idx: IndexPath)
    func getScripts() -> [Scripts]
}

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    var savedScripts = [Scripts]()
    var currentPage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        //challenge-1
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(showOptions))
        
        let defaults = UserDefaults.standard
             
         if let scripts = defaults.object(forKey: "Scripts") as? Data {
             let jsonDecoder = JSONDecoder()
             
             do {
                 savedScripts = try jsonDecoder.decode([Scripts].self, from: scripts)
             } catch {
                 print("Failed to load scripts.")
             }
         }

        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // When our extension is created, its extensionContext lets us control how it interacts with the parent app. In the case of inputItems this will be an array of data the parent app is sending to our extension to use.
    
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            // Our input item contains an array of attachments, which are given to us wrapped up as an NSItemProvider. Our code pulls out the first attachment from the first input item.
            if let itemProvider = inputItem.attachments?.first {
                // The next line uses loadItem(forTypeIdentifier: ) to ask the item provider to actually provide us with its item, but you'll notice it uses a closure so this code executes asynchronously. That is, the method will carry on executing while the item provider is busy loading and sending us its data.
                // Inside our closure we first need the usual [weak self] to avoid strong reference cycles, but we also need to accept two parameters: the dictionary that was given to us by the item provider, and any error that occurred.
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
//                    print(javaScriptValues)
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        self?.currentPage = self?.pageURL
                    }
                }
            }
        }
    }

    @IBAction func done() {
        compile(from: script.text)
        // save user defaults
        let newScript = Scripts(name: "New Script", url: currentPage!, script: script.text)
        
        savedScripts.append(newScript)
        save()
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
                
        if let savedScript = try? jsonEncoder.encode(savedScripts) {
            let defaults = UserDefaults.standard
            defaults.set(savedScript, forKey: "Scripts")
        } else {
            print("Failed to save new script.")
        }
    }
    
    @objc func showOptions() {
        let ac = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Example Scripts", style: .default, handler: { [weak self] _ in
            self?.showScripts()
        }))
        ac.addAction(UIAlertAction(title: "See Saved Scripts", style: .default, handler: { [weak self] _ in
            let tableView = TableViewController()
            tableView.scripts = self?.savedScripts ?? [Scripts]()
            tableView.delegate = self
            self?.navigationController?.pushViewController(tableView, animated: true)
        }))
        present(ac, animated: true, completion: nil)
    }
    
    func showScripts() {
        let ac = UIAlertController(title: "Example Scripts", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Show an alert", style: .default, handler: { [weak self] _ in
            self?.compile(from: "alert(\"Hacking With Swift\")")
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func compile(from script: String) {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item], completionHandler: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}

extension ActionViewController: ActionViewControllerDelegate {
    
    func loadScript(fromScript loadedScript: String) {
        script.text = loadedScript // or compile(from: script)
    }
    
    func deleteScript(idx scriptIndex: IndexPath) {
        savedScripts.remove(at: scriptIndex.row)
        save()
    }
    
    func renameScript(newName name: String, idx: IndexPath) {
        savedScripts[idx.row].name = name
        save()
    }
    
    func getScripts() -> [Scripts] {
        return savedScripts
    }
    
}


