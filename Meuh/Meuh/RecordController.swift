//
//  RecordController.swift
//  Meuh
//
//  Created by lienardr on 25/05/2022.
//
import CoreData
import UIKit
import AVFoundation
//Utilitaires d'enregistrement et de jouage de son
var audioRecorder: AVAudioRecorder!
var audioPlayer : AVAudioPlayer!

class RecordController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate  {
    
    //Boutons d'interaction
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var play_btn_ref: UIButton!
    
    // lael pour afficher la durée d'engregistrement
    @IBOutlet var recordingTimeLabel: UILabel!
    var meterTimer:Timer!
    //Variables d'état  du recorder/player
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Vérification des permission d'utilisation du micro sur navigation vers la view
        check_record_permission()
    }
    
    //On enregistre si la permission d'enregistrer est accordée ou non
    func check_record_permission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    //Méthode de récupération du chemin du dossier ou stocker le son
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //Concaténation du chemin du dossier précédemment trouvé avec le nom du fichier son
    func getFileUrl() -> URL
    {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    //Initialisation de l'utilitaire d'enregistrement
    func setup_recorder()
    {
        //Setup effectué uniquement si l'autorisation d'enregistrer est accordée
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                //Paramétrage de l'enregistreur avec la spécification du format de sortie et d'autres paramètre audios
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        }
        //Si on a pas l'autorisation d'enregistrer, affichage d'une alerte
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }
    }
    
    //fonction d'enregistrement ou d'arrêt de l'enregistrement, selon l'état de "isRecording", déclenchée sur appuie du bouton "Record/Stop"
    @IBAction func start_recording(_ sender: UIButton)
    {
        //Si on est en train d'enregistrer
        if(isRecording)
        {
            //Fin de l'enregistrement
            finishAudioRecording(success: true)
            //Le texte du bouton passe de "Stop" à "Record"
            record_btn_ref.setTitle("Record", for: .normal)
            //Le bouton "Play" s'active pour jouer le son enregistré
            play_btn_ref.isEnabled = true
            isRecording = false
        }
        //Si on est pas encore en train d'enregistrer
        else
        {
            //On paramètre l'enregistreur
            setup_recorder()
            //Lancement de l'enregistrement
            audioRecorder.record()
            //lancement du timer pour mesurer et afficher la durée.
            //toute les 0.1 seconde, la méthode de rafraichissement du label est appelée
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            //Le texte du bouton passe de "Record" à "Stop"
            record_btn_ref.setTitle("Stop", for: .normal)
            play_btn_ref.isEnabled = false
            isRecording = true
        }
    }
    
    //Méthode de rafraichissement du label d'affichage de la durée de l'enregistrement
    @objc func updateAudioMeter(timer: Timer)
    {
        //Vérification si on est bien en train d'enregistrer
        if audioRecorder.isRecording
        {
            //Conversion du timer de l'enregistreur en format heure/minute/seconde
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            //Mise à jour du label
            recordingTimeLabel.text = totalTimeString
            //Demande à l'enregistreur de rafraichir son timer
            audioRecorder.updateMeters()
        }
    }
    
    //Méthode de terminaison de l'enregistrement
    func finishAudioRecording(success: Bool)
    {
        //Si l'enregistrement a été un succès
        if success
        {
            //Arrêt de l'enregistreur
            audioRecorder.stop()
            audioRecorder = nil
            //arrêt du timer
            meterTimer.invalidate()
            print("recorded successfully.")
        }
        //Sinon
        else
        {
            //Message d'alerte
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    //Action gérant à la fois le lancement du son enregistré et sa pause si il est déjà lancé
    @IBAction func play_recording(_ sender: Any)
    {
        //Si le son est lancé
        if(isPlaying)
        {
            //Arrêt de uplayer
            audioPlayer.stop()
            //Activation du bouton d'enregistrement
            record_btn_ref.isEnabled = true
            //Changement du titre du bouton pour repasser de "Pause" à "Play"
            play_btn_ref.setTitle("Play", for: .normal)
            isPlaying = false
        }
        //Sinon
        else
        {
            if FileManager.default.fileExists(atPath: getFileUrl().path)
            {
                record_btn_ref.isEnabled = false
                play_btn_ref.setTitle("Pause", for: .normal)
                prepare_play()
                audioPlayer.play()
                isPlaying = true
            }
            else
            {
                display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
            }
        }
    }
    
    //Méthode
    func prepare_play()
    {
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }

    //Méthode utilitaire d'affichage de message
    func display_alert(msg_title : String , msg_desc : String ,action_title : String)
    {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
                     {
            (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
}
