//
//  Homework.swift
//  dragableHomework
//
//  Created by Samuel on 20-01-18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import Foundation
import UIKit

public struct Homework {
    
    var name : String?
    var viewColor: UIColor?
    var timeInterval : Int?
    
    public init (_ name: String, viewColor : UIColor? = nil, timeInterval : Int? = 1){
        self.name = name
        if(viewColor == nil){
            self.viewColor = generateRandomPastelColor()
        }else{
            self.viewColor = viewColor
        }
        if timeInterval! < 1{
            self.timeInterval = 1
        }else{
            self.timeInterval = timeInterval
        }
    }
    
}

