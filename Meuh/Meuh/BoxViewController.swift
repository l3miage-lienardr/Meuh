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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        view.frame = view.bounds
//
//        let screen = UIScreen.main.fixedCoordinateSpace
//
//        //These values will give a rect half the size of the screen and centered.
//        let width = screen.bounds.width / 2
//        let height = screen.bounds.height / 2
//        let x = (screen.bounds.width - width) / 2
//        let y = (screen.bounds.height - height) / 2
//        let absoluteRect = CGRect(x: x, y: y, width: width, height: height)
//
//        let stampRect = screen.convert(absoluteRect, to: view)
//        imageView.frame = stampRect

        //Change the orientation of the image
//        switch UIDevice.current.orientation {
//        case .landscapeLeft:
////            imageView.image = UIImage(cgImage: selectedImage!.cgImage!, scale: selectedImage!.scale, orientation: .left)
//            imageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
////            imageView.transform = CGAffineTransform(rotationAngle: -3 * CGFloat.pi/2)
//            break
//        case .landscapeRight:
//            imageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
////            imageView.image = UIImage(cgImage: selectedImage!.cgImage!, scale: selectedImage!.scale, orientation: .right)
//            break
//        case .portraitUpsideDown:
//            imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//        default:
//            imageView.transform = CGAffineTransform(rotationAngle: 0)
//        }
//        imageView.image!.fixImageOrientation()
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

extension UIImage {
    
    func fixImageOrientation() -> UIImage? {
        var flip:Bool = false //used to see if the image is mirrored
        var isRotatedBy90:Bool = false // used to check whether aspect ratio is to be changed or not
        
        var transform = CGAffineTransform.identity
        
        //check current orientation of original image
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.rotated(by: CGFloat(M_PI));
            
        case .left, .leftMirrored:
            transform = transform.rotated(by: CGFloat(M_PI_2));
            isRotatedBy90 = true
        case .right, .rightMirrored:
            transform = transform.rotated(by: CGFloat(-M_PI_2));
            isRotatedBy90 = true
        case .up, .upMirrored:
            break
        }
        
        switch self.imageOrientation {
            
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            flip = true
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            flip = true
        default:
            break;
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint(x:0, y:0), size: size))
        rotatedViewBox.transform = transform
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        
        //check if we have to fix the aspect ratio
        if isRotatedBy90 {
            bitmap?.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.height,height: size.width))
        } else {
            bitmap?.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width,height: size.height))
        }
        
        let fixedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return fixedImage
    }
}
