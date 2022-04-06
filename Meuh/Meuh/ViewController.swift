//
//  ViewController.swift
//  Meuh
//
//  Created by duriezk on 30/03/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var listTableView: UITableView!
    var pictures = [UIImage?]()
    var boxes = [Box]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let box = Box(title: "Meuh", imageName: "boite-a-meuh-publicitaire")
        let box2 = Box(title: "Corentin", imageName: "Corentin")
        let box3 = Box(title: "Nicolas", imageName: "Nicolas")
        
        boxes.append(box)
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
        nextViewController.paramToReceive = "Le type de box"
        nextViewController.selectedImage = UIImage(named: boxes[indexPath.row].imageName)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

}

