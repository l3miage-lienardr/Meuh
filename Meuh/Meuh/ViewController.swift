//
//  ViewController.swift
//  Meuh
//
//  Created by duriezk on 30/03/2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer?
    var currentDeviceOrientation: UIDeviceOrientation = .unknown
     
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
     
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceDidRotate(notification:)), name: UIDevice.orientationDidChangeNotification, object: nil)
     
            // Initial device orientation
        self.currentDeviceOrientation = UIDevice.current.orientation
            // Do what you want here
        }
     
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
     
        NotificationCenter.default.removeObserver(self)
        if UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
            }
        }
     
    @objc func deviceDidRotate(notification: NSNotification) {
            self.currentDeviceOrientation = UIDevice.current.orientation
        print(UIDevice.current.orientation.rawValue)
            playSound(sound: "cow", type: "mp3")
            // Do what you want here
        }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()    // Do any additional setup after loading the view.
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        playSound(sound: "cow", type: "mp3")
        
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
}
