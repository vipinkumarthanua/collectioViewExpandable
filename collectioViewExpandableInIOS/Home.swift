//
//  Home.swift
//  collectioViewExpandableInIOS
//
//  Created by vipin kumar on 10/20/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import Foundation
import UIKit

class Home {
    
    var homeName: String
    var person: [Person]
    var expanded: Bool
    
    init(homeName: String, person: [Person], expanded: Bool) {
        self.homeName = homeName
        self.person = person
        self.expanded = expanded
    }
}




class Person {
    
    var name: String
    var age: String
    var gender: String
    var image: UIImage
    
    init(name: String, age: String, gender: String, image: UIImage) {
        self.name = name
        self.age = age
        self.gender = gender
        self.image = image
    }
    
}
