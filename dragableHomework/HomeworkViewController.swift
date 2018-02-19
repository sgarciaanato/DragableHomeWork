//
//  HomeworkViewController.swift
//  dragableHomework
//
//  Created by Samuel on 19-01-18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit

class HomeworkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var usersArray = Array<User>()
    @IBOutlet weak var usersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usersTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        var arrayHomeworks = Array<Homework>()
        arrayHomeworks.append(Homework("Tarea 1"))
        arrayHomeworks.append(Homework("Tarea 2"))
        arrayHomeworks.append(Homework("Tarea 3"))
        
        usersArray.append(User("Primero", homeworks: arrayHomeworks))
        usersArray.append(User("Segundo", homeworks: Array<Homework>()))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
        usersTableView.addGestureRecognizer(longpress)
        
    }
    
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: usersTableView)
        var indexPath = usersTableView.indexPathForRow(at: locationInView)
        
        switch state {
        case UIGestureRecognizerState.began:
                if indexPath != nil {
                    Path.initialIndexPath = indexPath as! NSIndexPath
                    let cell = usersTableView.cellForRow(at: indexPath!) as! UserTableViewCell!
                    My.cellSnapshot  = snapshopOfCell(inputView: cell!)
                    var center = cell?.center
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.alpha = 0.0
                    usersTableView.addSubview(My.cellSnapshot!)
                    
                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
                        center?.y = locationInView.y
                        My.cellSnapshot!.center = center!
                        My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                        My.cellSnapshot!.alpha = 0.98
                        cell?.alpha = 0.0
                        
                    }, completion: { (finished) -> Void in
                        if finished {
                            cell?.isHidden = true
                        }
                    })
                }
        case .changed:
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            if ((indexPath != nil) && (indexPath  as! NSIndexPath != Path.initialIndexPath)) {
                swap(&usersArray[indexPath!.row], &usersArray[Path.initialIndexPath!.row])
                usersTableView.moveRow(at: Path.initialIndexPath as! IndexPath , to: indexPath!)
                Path.initialIndexPath = indexPath as! NSIndexPath
            }
        case .ended:
            if(indexPath  as! NSIndexPath == Path.initialIndexPath){
                usersTableView.reloadData()
            }
            let cell = usersTableView.cellForRow(at: indexPath!) as! UserTableViewCell!
            cell?.isHidden = false
            My.cellSnapshot!.removeFromSuperview()
        case .cancelled:
            let cell = usersTableView.cellForRow(at: indexPath!) as! UserTableViewCell!
            cell?.isHidden = false
            My.cellSnapshot!.removeFromSuperview()
        case .failed:
            let cell = usersTableView.cellForRow(at: indexPath!) as! UserTableViewCell!
            cell?.isHidden = false
            My.cellSnapshot!.removeFromSuperview()
            
        default:
            break
        }
    }
    
    struct My {
        static var cellSnapshot : UIView? = nil
    }
    struct Path {
        static var initialIndexPath : NSIndexPath? = nil
    }
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as! UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    @objc func addTapped(){
        let alert = UIAlertController(title: "Crea un nuevo usuario",
                                      message: nil,
                                      preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "Crear", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let nameTxt = alert.textFields![0].text
            self.usersArray.append(User(nameTxt!))
            self.usersTableView.reloadData()
            self.usersTableView.scrollToRow(at: IndexPath(row: self.usersArray.count - 1, section: 0), at: .middle, animated: true)
        })
        
        let cancel = UIAlertAction(title: "Cancelar", style: .destructive, handler: { (action) -> Void in })
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Escribe su nombre"
        }
        alert.addAction(createAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Editar usuario",
                                      message: nil,
                                      preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "Editar", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let nameTxt = alert.textFields![0].text
            self.usersArray[indexPath.row].name = nameTxt
            self.usersTableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "Cancelar", style: .destructive, handler: { (action) -> Void in  })
        let delete = UIAlertAction(title: "Eliminar", style: .destructive, handler: { (action) -> Void in
            self.usersArray.remove(at: indexPath.row)
                self.usersTableView.reloadData()
        })
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Escribe su nombre"
            textField.text = self.usersArray[indexPath.row].name
        }
        alert.addAction(createAction)
        alert.addAction(delete)
        alert.addAction(cancel)
    
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if(screenWidth < screenHeight){
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        
        cell.setUser(user: usersArray[indexPath.row])
        cell.parentViewController = self
        cell.selectionStyle = .none
        cell.homeworkCollectionView.reloadData()
        
        return cell
        
        
    }
    
    func updateHomeworkFromUser(updateUser: User){
        for i in 0..<usersArray.count{
            if(updateUser.id == usersArray[i].id){
                usersArray[i].homeworks = updateUser.homeworks
            }
        }
    }
    
}
