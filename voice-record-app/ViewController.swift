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
//class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
//    class ViewController: UIViewController{
    let TODO = ["牛乳を買う", "掃除をする", "アプリ開発の勉強をする"] //追加②
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TODO.count
    }

    //追加④ セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = TODO[indexPath.row]
        return cell
    }

    // delegate => tableViewで例える
    // 必須のメソッド、numberOfRowsInSectionやcellForRowAtなどがあるがこれを定義しておけば
    // UITableViewDelegate,UITableViewDataSourceを宣言する必要もないし、
    // tableView.dataSource = selfする必要もないし、そもそもこれがなくても動作する
    // まだdelegateの存在意味をわかっていない。 =>
    // 一覧表示で実装してみたが、tableView.dataSource = self
    // tableView.delegate = selfこの２つをコメントアウトするとtableViewに定義したTodoリストが表示されなくなった。
    // => これによりdeletegaはphpでいうインターフェースと同じものだと思っていたがこれで違うものだとわかった。、
    // しかし、AVAudioRecorderDelegate,AVAudioPlayerDelegateでは宣言しなくても動く。
    // だだAVAudioRecorderDelegate,AVAudioPlayerDelegateはviewDidLoadでtableView.dataSource = selfのような委託処理をやっていない。
    // => delegateわからん。
    @IBOutlet weak var recordBTN: UIButton!
    var soundRecorder: AVAudioRecorder!
    var fileName = "record.m4a"
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupRecoder()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBOutlet weak var tableView: UITableView!
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

