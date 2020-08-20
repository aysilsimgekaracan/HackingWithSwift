//
//  ViewController.swift
//  Project10
//
//  Created by Ayşıl Simge Karacan on 13.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // UIImagePickerControllerDelegate -> telling us when the user either selected a picture or cancelled the picker.
    // UINavigationControllerDelegate -> Use a navigation controller delegate (a custom object that implements this protocol) to modify behavior when a view controller is pushed or popped from the navigation stack of a UINavigationController object.
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople
            }
        }
        
        // END OF VIEW_DID_LOAD
    }
    
    @objc func addNewPerson() {
        // UIImagePickerController is new class is designed to let users select an image from their camera to import into an app
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        // We set the allowsEditing property to be true, which allows the user to crop the picture they select.
        picker.allowsEditing = true
        
        // The delegate receives notifications when the user picks an image or movie, or exits the picker interface. The delegate also decides when to dismiss the picker interface, so you must provide a delegate to use a picker.
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    // This method tells the delegate that the user picked a still image or movie.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // .editedImage -> the image that was edited
        guard let image = info[.editedImage] as? UIImage else { return }
        
        //  Generate a unique filename for every image
        let imageName = UUID().uuidString
        
        // Returns a URL constructed by appending the given path component to self.
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        // Now that we have a UIImage containing an image and a path where we want to save it, we need to convert the UIImage to a Data object so it can be saved. To do that, we use the jpegData() method, which takes one parameter: a quality value between 0 and 1, where 1 is “maximum quality”.
        // Once we have a Data object containing our JPEG data, we just need to unwrap it safely then write it to the file name we made earlier. That's done using the write(to:) method, which takes a filename as its parameter.
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView?.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        // The first parameter of FileManager.default.urls asks for the documents directory, and its second parameter adds that we want the path to be relative to the user's home directory. This returns an array that nearly always contains only one thing: the user's documents directory. So, we pull out the first element and return it.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // Line 1 is what converts our array into a Data object, then lines 2 and 3 save that data object to UserDefaults. You now just need to call that save() method when we change a person's name or when we import a new picture.
    func save() {
        // NSKeyedArchiver, a concrete subclass of NSCoder, provides a way to encode objects (and scalar values) into an architecture-independent suitable for storage in a file.
        // archivedData -> Encodes an object graph with the given root object into a data representation, optionally requiring secure coding.
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }

    }
    
    // MARK: COLLECTION VIEW
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.save()
            self?.collectionView.reloadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        }))
        
        present(ac, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            // Unconditionally prints a given message and stops execution.
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    // END OF VIEW_CONTROLLER CLASS
}

