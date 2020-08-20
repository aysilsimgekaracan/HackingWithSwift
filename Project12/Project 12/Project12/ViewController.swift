//
//  ViewController.swift
//  Project12
//
//  Created by Ayşıl Simge Karacan on 20.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaults -> An interface to the user’s defaults database, where you store key-value pairs persistently across launches of your app.
        let defaults = UserDefaults.standard
        
        defaults.set(25, forKey: "Age") // Sets the value of the specified default key to the specified integer value.
        defaults.set(true, forKey: "UserFaceID")
        defaults.set(CGFloat.pi, forKey: "pi")
        
        defaults.set("Paul Hudson", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")
        
        let array = ["Hello", "World"]
        defaults.set(array, forKey: "SavedArray")
        
        let dict = ["Name": "Paul", "Country": "UK"]
        defaults.set(dict, forKey: "SavedDictionary")
        
        let savedInteger = defaults.integer(forKey: "Age") // Returns the integer value associated with the specified key.
        let savedBoolen = defaults.bool(forKey: "UseFaceID")
        
        let savedArray = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()
        let savedDictionary = defaults.object(forKey: "SavedDictionary") as? [String: String] ?? [String: String]()
        
    }


}

