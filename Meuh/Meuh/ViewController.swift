//
//  ViewController.swift
//  Meuh
//
//  Created by duriezk on 30/03/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pictures = [UIImage?]()
    var boxes = [Box]()
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var button: UIButton!
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let box = Box(title: "Meuh", imageName: "boite-a-meuh-publicitaire", sound: "cow")
        let box1 = Box(title: "Chevre", imageName: "chevre", sound:"Chevre")
        let box4 = Box(title: "Cochon", imageName: "cochon", sound:"cochon")
        let box5 = Box(title: "Canard", imageName: "canard", sound:"canard")
        let box2 = Box(title: "Corentin", imageName: "Corentin", sound:"Chevre")
        let box3 = Box(title: "Nicolas", imageName: "Nicolas", sound:"canard")
        
        boxes.append(box)
        boxes.append(box1)
        boxes.append(box4)
        boxes.append(box5)
        boxes.append(box2)
        boxes.append(box3)
        
        listTableView.delegate = self
        listTableView.dataSource = self
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! BoxCell
        cell.titleLabel.text = boxes[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboad.instantiateViewController(withIdentifier: "box") as! BoxViewController
        nextViewController.selectedImage = UIImage(named: boxes[indexPath.row].imageName)
        nextViewController.selectedSound=boxes[indexPath.row].sound
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

