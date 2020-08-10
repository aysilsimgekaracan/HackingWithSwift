//
//  Petitions.swift
//  Project7
//
//  Created by Ayşıl Simge Karacan on 7.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import Foundation

struct Petitions: Codable {
    var results: [Petition]
}



//Swift’s Codable protocol needs to know exactly where to find its data, which in this case means making a second struct. This one will have a single property called results that will be an array of our Petition struct. This matches exactly how the JSON looks: the main JSON contains the results array, and each item in that array is a Petition.
