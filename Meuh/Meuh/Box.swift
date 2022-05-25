//
//  Box.swift
//  Meuh
//
//  Created by duriezk on 06/04/2022.
//

import Foundation

class Box {
    var title: String!
    var imageName: String
    var sound: String
    
    init(title: String, imageName: String, sound: String) {
        self.title = title
        self.imageName = imageName
        self.sound=sound
    }
}
