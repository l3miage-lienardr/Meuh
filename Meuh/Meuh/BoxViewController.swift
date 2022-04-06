//
//  BoxViewController.swift
//  Meuh
//
//  Created by duriezk on 04/04/2022.
//

import UIKit

class BoxViewController: UIViewController {

    var paramToReceive: String?
    @IBOutlet var imageView : UIImageView!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageToLoad = selectedImage {
            imageView.image  = imageToLoad
        }
        
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
