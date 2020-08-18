//
//  ViewController.swift
//  Project1
//
//  Created by Ayşıl Simge Karacan on 26.07.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.reloadData()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        pictures.sort()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
        
        vc.selectedImage = pictures[indexPath.row]
        vc.totalImage = pictures.count
        vc.selectedImageIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Unable to dequeue PictureCell.")
        }
        cell.nameLabel.text = pictures[indexPath.row]
        cell.imageView.image = UIImage(named: pictures[indexPath.row])
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        //cell.textLabel?.text =  pictures[indexPath.row] //"Picture \(indexPath.row + 1) of \(pictures.count)"
        return cell
    }
    
    
    
    @objc func shareTapped() {
            let shareString = ["If you've liked the app, share the app with others!"]
            let shareUrl = URL(string: "https://www.stormviewer.com")
            
        let vc = UIActivityViewController(activityItems: [shareString, shareUrl!], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        
    }
     


}

