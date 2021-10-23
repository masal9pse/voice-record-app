//
//  ViewController.swift
//  voice-record-app
//
//  Created by 山本大翔 on 2021/10/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Request permission to record.
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                // The user granted access. Present recording interface.
            } else {
                // Present message to user indicating that recording
                // can't be performed until they change their preference
                // under Settings -> Privacy -> Microphone
            }
        }
    }


}

