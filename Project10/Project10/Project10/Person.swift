//
//  Person.swift
//  Project10
//
//  Created by Ayşıl Simge Karacan on 17.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

// NSObject is what's called a universal base class for all Cocoa Touch classes. That means all UIKit classes ultimately come from NSObject, including all of UIKit.

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
