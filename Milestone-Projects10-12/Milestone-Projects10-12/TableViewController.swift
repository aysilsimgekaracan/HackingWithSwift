//
//  ViewController.swift
//  Milestone-Projects10-12
//
//  Created by Ayşıl Simge Karacan on 26.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var photos = [Photos]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
        
        let defaults = UserDefaults.standard
        
        if let savedPhotos = defaults.object(forKey: "Photos") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                photos = try jsonDecoder.decode([Photos].self, from: savedPhotos)
            } catch {
                print("Failed to load Photos")
            }
        }
        // END OF VIEW_DID_LOAD
    }
    
    @objc func addNewPhoto() {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        
        let imagePATH = getDocumentsDirectroy().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePATH)
        }
        dismiss(animated: true, completion: nil)
        
        
        let ac = UIAlertController(title: "Add caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let addButton = UIAlertAction(title: "Add", style: .default) { [weak ac, weak self] _ in
            let caption = ac?.textFields?[0].text ?? "Unknown"
            self?.addPhoto(path: imagePATH.path, caption: caption)
        }
        ac.addAction(addButton)
        present(ac, animated: true)
    }
    
    func getDocumentsDirectroy() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func addPhoto(path imagePath: String, caption: String) {
        let photo = Photos(image: imagePath, caption: caption)
        photos.append(photo)
        save()
        tableView.reloadData()
        
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "Photos")
        } else {
            print("Failed to save photo")
        }
    }
    
    //MARK: TABLE VIEW
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedPhoto = photos[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let photo = photos[indexPath.item]
        cell.textLabel?.text = photo.caption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            photos.remove(at: indexPath.row)
            save()
        }
        tableView.reloadData()
    }
}
