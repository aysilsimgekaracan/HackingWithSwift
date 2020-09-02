//
//  Countries.swift
//  Milestone-Project13-15
//
//  Created by Ayşıl Simge Karacan on 2.09.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import Foundation

struct Countries: Codable {
    let name: String
    let alpha2Code: String // ISO 3166 code
    let capital: String
    let region: String
    let subregion: String
    let population: Int
    let demonym: String
    let flag: String
    
}


