//
//  ViewController.swift
//  Watch_Sample
//
//  Created by terada enishi on 2021/06/09.
//

import UIKit
//Watchとの接続の役割
import WatchConnectivity

//WCSessionDelegateを追加
class ViewController: UIViewController, WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    //Watchに送信する数字
    var sendInt: Int!
    @IBOutlet weak var receiveLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func sendButton(_ sender: Any) {
        //カウントを1進める
        sendInt += 1
        //messageにsendIntをセット、keyとしてsendを設定
        let message = ["send" :sendInt.description]
        //Watchにデータを送る処理
        WCSession.default.sendMessage(message, replyHandler:  { reply in print(reply) }, errorHandler: { error in print(error.localizedDescription)})
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //WatchConnectivityのSession開始
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        //数字の初期化
        sendInt = 0
    }

    //Watchからデータを受け取った時の処理
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {() -> Void in
            self.receiveLabel.text = message["send"] as? String
            self.timeLabel.text = message["date"] as? String
            replyHandler(["watch" : "OK"])
        }
        
    }
    
}

