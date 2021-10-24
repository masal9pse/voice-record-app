//
//  ViewController.swift
//  voice-record-app
//
//  Created by 山本大翔 on 2021/10/24.
//

import UIKit
import AVFoundation

//class ViewController: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
//class ViewController: UIViewController,AVAudioPlayerDelegate {
class ViewController: UIViewController {
    @IBOutlet weak var recordBTN: UIButton!
    var soundRecorder: AVAudioRecorder!
    var fileName = "record.m4a"
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupRecoder()
    }
    
    func getDocumentsDirector() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupRecoder() {
        let dt = Date()
        let dateFormatter = DateFormatter()

        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMdkHms", options: 0, locale: Locale(identifier: "ja_JP"))

        print(dateFormatter.string(from: dt))
        let jpDate = dateFormatter.string(from: dt)
        let audioFilename = getDocumentsDirector().appendingPathComponent(jpDate + fileName)
        let recordSetting = [ AVFormatIDKey: kAudioFormatAppleLossless
                              ,AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                        AVEncoderBitRateKey: 3200,
                      AVNumberOfChannelsKey: 2,
                            AVSampleRateKey: 44100.2
        ] as [String: Any]
        
        do {
            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting)
//            let session = AVAudioSession.sharedInstance()
//            try session.setCategory(AVAudioSessionCategoryRecord)
//            try session.setActive(true)
            soundRecorder.prepareToRecord()
        } catch {
            print(error)
        }
    }
    
    
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        playBTN.isEnabled = true
//    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBTN.isEnabled = true
    }
    
    @IBAction func recordAct(_ sender: Any) {
        if recordBTN.titleLabel?.text == "Record" {
            setupRecoder()
            soundRecorder.record()
            recordBTN.setTitle("Stop", for: .normal)
        } else {
            soundRecorder.stop()
            let session = AVAudioSession.sharedInstance()
            try! session.setActive(false)
            recordBTN.setTitle("Record", for: .normal)
        }
    }
}

