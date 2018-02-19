//
//  UserTableViewCell.swift
//  dragableHomework
//
//  Created by Samuel on 20-01-18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, HSBColorPickerDelegate,UICollectionViewDelegateFlowLayout {
    
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        cardColor = color
        showColor.backgroundColor = cardColor
    }
    
    var user : User?
    var parentViewController: HomeworkViewController?
    @IBOutlet weak var homeworkCollectionView: UICollectionView!
    @IBOutlet weak var homeworkCollectionViewFlowLayout: UICollectionViewFlowLayout!
    var cardColor = UIColor.blue
    let showColor = UIView(frame: CGRect(x: 20, y: 50, width: 230, height: 20))
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        homeworkCollectionView.register(UINib(nibName: "HomeworkCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "HomeworkCollectionViewCell")
        homeworkCollectionViewFlowLayout.itemSize = CGSize(width: 200 , height: homeworkCollectionView.frame.height - 8 )
        
        homeworkCollectionView.delegate = self
        homeworkCollectionView.dataSource = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        homeworkCollectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Editar nueva tarea",
                                      message: "\n\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        
        let picker = HSBColorPicker(frame: CGRect(x: 20, y: 70, width: 230, height: 50))
        let timeIntervalPicker = UIDatePicker(frame: CGRect(x: 20, y: 120, width: 230, height: 80))
        timeIntervalPicker.datePickerMode = .countDownTimer
        timeIntervalPicker.minuteInterval = 15
        
        let createAction = UIAlertAction(title: "Editar", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let nameTxt = alert.textFields![0].text
            self.user?.homeworks?[indexPath.row].name = nameTxt
            var time = Int(timeIntervalPicker.countDownDuration / (60 * 15))
            if(time < 1){
                time = 1
            }
            self.user?.homeworks?[indexPath.row].timeInterval = time
            self.user?.homeworks?[indexPath.row].viewColor = self.cardColor
            self.homeworkCollectionView.reloadData()
            self.parentViewController?.updateHomeworkFromUser(updateUser: self.user!)
        })
        
        let cancel = UIAlertAction(title: "Cancelar", style: .destructive, handler: { (action) -> Void in })
        let delete = UIAlertAction(title: "Eliminar", style: .destructive, handler: { (action) -> Void in
            self.user?.homeworks?.remove(at: indexPath.row)
            self.homeworkCollectionView.reloadData()
        })
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Escribe el nombre de la tarea"
            if(indexPath.row < (self.user?.homeworks?.count)!){
                textField.text = self.user?.homeworks?[indexPath.row].name
            }
        }
        
        alert.addAction(createAction)
        alert.addAction(delete)
        alert.addAction(cancel)
        alert.view.addSubview(picker)
        showColor.backgroundColor = self.cardColor
        alert.view.addSubview(showColor)
        alert.view.addSubview(timeIntervalPicker)
        picker.delegate = self
        DispatchQueue.main.async {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addHomeworkAction(_ sender: Any) {
        let alert = UIAlertController(title: "Crea una nueva tarea",
                                      message: "\n\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        
        let picker = HSBColorPicker(frame: CGRect(x: 20, y: 70, width: 230, height: 50))
        let timeIntervalPicker = UIDatePicker(frame: CGRect(x: 20, y: 120, width: 230, height: 80))
        timeIntervalPicker.datePickerMode = .countDownTimer
        timeIntervalPicker.minuteInterval = 15
        
        let createAction = UIAlertAction(title: "Crear", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let nameTxt = alert.textFields![0].text// nameTxt!, viewColor : self.cardColor Int(timeIntervalPicker.countDownDuration / (60 * 15)
            var time = Int(timeIntervalPicker.countDownDuration / (60 * 15))
            if(time < 1){
                time = 1
            }
            self.user?.homeworks?.append(Homework(nameTxt!, viewColor: self.cardColor, timeInterval: time))
            self.homeworkCollectionView.reloadData()
            self.parentViewController?.updateHomeworkFromUser(updateUser: self.user!)
            self.homeworkCollectionView.scrollToItem(at: IndexPath(row: (self.user?.homeworks!.count)! - 1, section: 0), at: .right, animated: true)
        })
        
        let cancel = UIAlertAction(title: "Cancelar", style: .destructive, handler: { (action) -> Void in })
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Escribe el nombre de la tarea"
        }
        
        alert.addAction(createAction)
        alert.addAction(cancel)
        alert.view.addSubview(picker)
        showColor.backgroundColor = self.cardColor
        alert.view.addSubview(showColor)
        alert.view.addSubview(timeIntervalPicker)
        picker.delegate = self
        DispatchQueue.main.async {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = homeworkCollectionView.indexPathForItem(at: gesture.location(in: homeworkCollectionView)) else {
                break
            }
            homeworkCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            homeworkCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            homeworkCollectionView.endInteractiveMovement()
            homeworkCollectionView.reloadData()
            self.parentViewController?.updateHomeworkFromUser(updateUser: self.user!)
        default:
            homeworkCollectionView.cancelInteractiveMovement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var indexpaths = Array<IndexPath>()
        if(sourceIndexPath.item > destinationIndexPath.item){
            for i in destinationIndexPath.item...sourceIndexPath.item-1{
                let auxHomework = user?.homeworks![i]
                user?.homeworks![i] = (user?.homeworks![i + 1])!
                user?.homeworks![i + 1] = auxHomework!
                indexpaths.append(IndexPath(row: i, section: 0))
            }
        }else{
            for i in sourceIndexPath.item...destinationIndexPath.item-1{
                let auxHomework = user?.homeworks![i]
                user?.homeworks![i] = (user?.homeworks![i + 1])!
                user?.homeworks![i + 1] = auxHomework!
                indexpaths.append(IndexPath(row: i, section: 0))
            }
        }
        self.homeworkCollectionView.reloadItems(at: indexpaths)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tamano = 200 * (self.user?.homeworks?[indexPath.row].timeInterval)!
        let margins = 10 * ((self.user?.homeworks?[indexPath.row].timeInterval)! - 1)
        return CGSize(width: CGFloat(tamano + margins), height: homeworkCollectionView.frame.height - 8)
    }
    
    func setUser(user: User?){
        self.user = user
        self.name.text = self.user?.name
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(user == nil || user?.homeworks == nil){
            return 0
        }
        return (user?.homeworks?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeworkCollectionViewCell", for: indexPath) as! HomeworkCollectionViewCell
        
        cell.setHomework(homework: user?.homeworks![indexPath.row])
        
        return cell
    }
    
}
