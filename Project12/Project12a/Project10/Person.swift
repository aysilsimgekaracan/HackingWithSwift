//
//  Person.swift
//  Project10
//
//  Created by Ayşıl Simge Karacan on 17.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

// NSObject is what's called a universal base class for all Cocoa Touch classes. That means all UIKit classes ultimately come from NSObject, including all of UIKit.

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    // The NSCoding protocol declares the two methods that a class must implement so that instances of that class can be encoded and decoded. This capability provides the basis for archiving (where objects and other structures are stored on disk) and distribution (where objects are copied to different address spaces).
    // If your data type is a class, it must conform to the NSCoding protocol, which is used for archiving object graphs.
    
    // The initializer is used when loading objects of this class, and encode() is used when saving.
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
}


