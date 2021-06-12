//
//  InterfaceController.swift
//  Watch_Sample WatchKit Extension
//
//  Created by terada enishi on 2021/06/09.
//

import WatchKit
import Foundation
//iOSとの接続の役割
import WatchConnectivity

//WCSessionDelegateを追加
class InterfaceController: WKInterfaceController,WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    @IBOutlet weak var sendTable: WKInterfaceTable!
    //Tableに表示するデータ
    let emojis = ["🐱 ネコ","🐲 ドラゴン","🦄 ユニコーン","🌵 サボテン","😀 えがお"]
    @IBOutlet weak var receiveLabel: WKInterfaceLabel!
    @IBAction func sendButton() {
        //カウントを1進める
        sendInt += 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = dateFormatter.string(from: Date())
        
        //送信するメッセージ(数字と日付)
        let message = ["send": sendInt.description,"date": date]
        
        //Watchにデータを送る処理
        WCSession.default.sendMessage(message, replyHandler:  { reply in print(reply) }, errorHandler: { error in print(error.localizedDescription)})
    }
    
    //iPhoneに送信する数字
    var sendInt: Int!
    override func awake(withContext context: Any?) {
        //WatchConnectivityのSession開始
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        //数字の初期化
        sendInt = 0
        
        //Tableの数を指定(emojisの数だけ生成)
        sendTable.setNumberOfRows(emojis.count, withRowType: "row")
         
        //生成したTableにデータを入れていく(index=データの番号、item=データそのもの)
        for (index, item) in emojis.enumerated() {
            let row = sendTable.rowController(at: index) as! TableSetUp
            row.tableLabel.setText(item)
        }
    }
    
    //Tableをタップした時の処理
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = dateFormatter.string(from: Date())
        
        //送信するメッセージ(絵文字と日付)
        let message = ["send": self.emojis[rowIndex],"date": date]
        
        //Watchにデータを送る処理
        WCSession.default.sendMessage(message, replyHandler:  { reply in print(reply) }, errorHandler: { error in print(error.localizedDescription)})
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    //iOSからデータを受け取った時の処理
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        receiveLabel.setText(message["send"] as? String)
        replyHandler(["watch" : "OK"])
    }
}
