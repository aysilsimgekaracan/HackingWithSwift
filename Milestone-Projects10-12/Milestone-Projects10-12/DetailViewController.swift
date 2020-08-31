//
//  DetailViewController.swift
//  Milestone-Projects10-12
//
//  Created by Ayşıl Simge Karacan on 26.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedPhoto: Photos?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "\(String(describing: selectedPhoto!.caption))"
        
        if let photoToLoad = selectedPhoto?.image {
            print(selectedPhoto?.image)
            print(photoToLoad)
            imageView.image = UIImage(named: photoToLoad)
        } else {
            fatalError("Cannot find photoToLoad")
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
    


}
