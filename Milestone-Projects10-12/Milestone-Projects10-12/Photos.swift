//
//  Photos.swift
//  Milestone-Projects10-12
//
//  Created by Ayşıl Simge Karacan on 26.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import Foundation

class Photos: Codable {
    var image: String
    var caption: String
    
    init(image: String, caption: String) {
        self.image = image
        self.caption = caption
    }
}
