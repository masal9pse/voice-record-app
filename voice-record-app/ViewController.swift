//
//  ViewController.swift
//  voice-record-app
//
//  Created by 山本大翔 on 2021/10/24.
//

import UIKit
import AVFoundation

//class ViewController: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
class ViewController: UIViewController,AVAudioPlayerDelegate {
    @IBOutlet weak var recordBTN: UIButton!
    @IBOutlet weak var playBTN: UIButton!
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    var fileName = "audioFile.m4a"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecoder()
        playBTN.isEnabled = false
    }
    
    func getDocumentsDirector() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupRecoder() {
        let audioFilename = getDocumentsDirector().appendingPathComponent(fileName)
        let recordSetting = [ AVFormatIDKey: kAudioFormatAppleLossless
                              ,AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                        AVEncoderBitRateKey: 3200,
                      AVNumberOfChannelsKey: 2,
                            AVSampleRateKey: 44100.2
        ] as [String: Any]
        
        do {
            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting)
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryRecord)
            try session.setActive(true)
//            soundRecorder.delegate = self
//            soundRecorder.prepareToRecord()
            soundRecorder.prepareToRecord()
        }catch {
            print(error)
        }
    }
    
    // ２回目に再生すると音が聞こえなくなる。
    func setupPlayer(){
        let audioFilename = getDocumentsDirector().appendingPathComponent(fileName)
        do{
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryAmbient)
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
          print(error)
        print(333)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playBTN.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBTN.isEnabled = true
        playBTN.setTitle("play", for: .normal)
    }
    
    @IBAction func recordAct(_ sender: Any) {
        if recordBTN.titleLabel?.text == "Record" {
            soundRecorder.record()
            recordBTN.setTitle("Stop", for: .normal)
            playBTN.isEnabled = false
        } else {
            soundRecorder.stop()
            let session = AVAudioSession.sharedInstance()
            try! session.setActive(false)
            recordBTN.setTitle("Record", for: .normal)
            playBTN.isEnabled = true
        }
    }
    
    @IBAction func playAct(_ sender: Any) {
        if playBTN.titleLabel?.text == "Play" {
            playBTN.setTitle("Stop", for: .normal)
            recordBTN.isEnabled = false
            setupPlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            playBTN.setTitle("Play", for: .normal)
            recordBTN.isEnabled = false
        }
    }
}

