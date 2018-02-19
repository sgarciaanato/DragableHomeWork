//
//  HomeworkCollectionViewCell.swift
//  dragableHomework
//
//  Created by Samuel on 20-01-18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit

class HomeworkCollectionViewCell: UICollectionViewCell {

    var homework: Homework?
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func setHomework(homework: Homework?){
        self.homework = homework
        self.name.text = self.homework?.name
        
        self.name.backgroundColor = self.homework?.viewColor?.withAlphaComponent(0.2)
        self.name.textColor = self.homework?.viewColor
        self.upperView.backgroundColor = self.homework?.viewColor
        
        if(homework?.viewColor?.isLight())!{
            self.name.textColor = UIColor.black
            self.upperView.backgroundColor = UIColor.black
        }
        
    }

}
