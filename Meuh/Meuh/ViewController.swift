//
//  ViewController.swift
//  Meuh
//
//  Created by duriezk on 30/03/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var listTableView: UITableView!
    var pictures = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fm = FileManager.default
        let path = fm.currentDirectoryPath
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            pictures.append(item)
        }
        print(path)
        print(pictures)
       
        listTableView.delegate = self
        listTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboad.instantiateViewController(withIdentifier: "box") as! BoxViewController
        nextViewController.paramToReceive = "Le type de box"
        nextViewController.selectedImage = pictures[indexPath.row]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

}

