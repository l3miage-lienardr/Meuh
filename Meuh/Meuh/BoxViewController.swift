//
//  BoxViewController.swift
//  Meuh
//
//  Created by duriezk on 04/04/2022.
//

import UIKit
import AVFoundation

class BoxViewController: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet var imageView : UIImageView!
    var selectedImage: UIImage?
    var selectedSound: String=""
    
    var player: AVAudioPlayer?
    var audioPlayer : AVAudioPlayer!
    var currentDeviceOrientation: UIDeviceOrientation = .unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageToLoad = selectedImage {
            imageView.image  = imageToLoad
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        playSound(sound: selectedSound, type: "mp3")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        if UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceDidRotate(notification:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Initial device orientation
        self.currentDeviceOrientation = UIDevice.current.orientation
        // Do what you want here
    }
    
    @objc func deviceDidRotate(notification: NSNotification) {
        self.currentDeviceOrientation = UIDevice.current.orientation
        print(UIDevice.current.orientation.rawValue)
        playSound(sound: selectedSound, type: "mp3")
        // Do what you want here
    }
    
    func playSound(sound :String, type : String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player?.play()
            } catch {
                print("Could not play the sound file" + sound)
            }
        }
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
