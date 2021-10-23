//
//  ViewController.swift
//  voice-record-app
//
//  Created by 山本大翔 on 2021/10/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    @IBOutlet weak var recordBTN: UIButton!
    @IBOutlet weak var playBTN: UIButton!
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    var fileName = "audioFile.m4a"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func recordAct(_ sender: Any) {}
    @IBAction func playAct(_ sender: Any) {
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
//            soundRecorder.delegate = self
//            soundRecorder.prepareToRecord()
            soundRecorder.prepareToRecord()
        }catch {
            print(error)
        }
    }
}

