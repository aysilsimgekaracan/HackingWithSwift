//
//  DetailViewController.swift
//  Project1
//
//  Created by Ayşıl Simge Karacan on 27.07.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    var selectedImageIndex: Int?
    var totalImage: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pictures \(String(describing: selectedImageIndex!)) of \(String(describing: totalImage!))"
        navigationItem.largeTitleDisplayMode = .never
        //FOR PROJECT 3
        /*
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
         */
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    //FOR PROJECT 3
    /*
    
    @objc func shareTapped() {
        // For sharing the image
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
        
            print("No image found")
            return
        }
        
        guard let imageName = selectedImage else {
            print("No image name found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
         
        
        // activityItems -> The array of data objects on which to perform the activity.
        // applicationActivities -> An array of UIActivity objects representing the custom services that your application supports. This parameter may be nil.
        //For sharing text
        //guard var ListOfImages = ?
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
 */


}
