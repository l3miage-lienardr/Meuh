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
    
    let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Chargement de l'image de boit à meuh
        if let imageToLoad = selectedImage {
            imageView.image  = imageToLoad
            
            imageView.frame = CGRect(x: 10, y: 10, width: screenSize.width - 10, height: screenSize.height - 50)
        }
        
        // Do any additional setup after loading the view.
    }

    
    //A l'arrivée sur la vue, on génère des notifications d'orientation de l'appareil
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceDidRotate(notification:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Initial device orientation
        self.currentDeviceOrientation = UIDevice.current.orientation
        // Do what you want here
    }
    
    
    //Lorsque on quitte la vue, on enlève l'observer et la génération de notifications
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        if UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
    }
    
    //Calcul de la taille de l'écran pour redimensionner l'image selon le sens de rotation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.frame = view.bounds

        let screen = UIScreen.main.fixedCoordinateSpace

        //These values will give a rect half the size of the screen and centered.
        let width = screen.bounds.width / 2
        let height = screen.bounds.height / 2
        let x = (screen.bounds.width - width) / 2
        let y = (screen.bounds.height - height) / 2
        let absoluteRect = CGRect(x: x, y: y, width: width, height: height)

        let stampRect = screen.convert(absoluteRect, to: view)
        imageView.frame = stampRect
    }
    
    //Méthode appelée lorsqu'une notification de rotation d'écran est reçue
    @objc func deviceDidRotate(notification: NSNotification) {
        self.currentDeviceOrientation = UIDevice.current.orientation
        print(UIDevice.current.orientation.rawValue)
        //Lancement du son
        playSound(sound: selectedSound, type: "mp3")
        // Rotation de l'image pour s'adapter au sens de l'écran
                switch UIDevice.current.orientation {
                case .landscapeLeft:
                    imageView.transform = CGAffineTransform(rotationAngle: 3*CGFloat.pi/2)
                    break
                case .landscapeRight:
                    imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                    break
                case .portraitUpsideDown:
                    imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                default:
                    imageView.transform = CGAffineTransform(rotationAngle: 0)
                }

    }
    //Méthode de lancement du son
    func playSound(sound :String, type : String) {
        //Récupération du chemin du fichier son
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

