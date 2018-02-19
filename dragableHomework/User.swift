//
//  User.swift
//  dragableHomework
//
//  Created by Samuel on 20-01-18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import Foundation

public struct User {
    
    var name : String?
    var homeworks : Array<Homework>?
    let id = NSUUID().uuidString
    
    public init (_ name: String, homeworks: Array<Homework>? = Array<Homework>()){
        self.name = name
        self.homeworks = homeworks
    }

}
