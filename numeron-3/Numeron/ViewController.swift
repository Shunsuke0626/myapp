//
//  ViewController.swift
//  Numeron
//
//  Created by 中村俊輔 on 2018/08/05.
//  Copyright © 2018年 shunsuke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import JSQMessagesViewController

class ViewController: JSQMessagesViewController, UITextFieldDelegate {
    var myAnswerNumber: String = "0"
    var enemyAnswerNumber: Int = 0
    var myCallNumber: Int = 0
    var enemyCallNumber:Int = 0
    var roomNumber:String = "0"
    // データベースへの参照を定義
    var ref: DatabaseReference!
    // メッセージ内容に関するプロパティ
    var messages: [JSQMessage]?
    // 背景画像に関するプロパティ
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    // アバター画像に関するプロパティ
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    // UUIDの取得
    let uuidString = UUID().uuidString
    
    func setupFirebase() {
        // DatabaseReferenceのインスタンス化
        ref = Database.database().reference()
        
        // 最新25件のデータをデータベースから取得する
        // 最新のデータが追加されるたびに最新データを取得する
        ref.child("rooms").child(roomNumber).queryLimited(toLast: 25).observe(DataEventType.childAdded, with: { (snapshot) -> Void in
            let snapshotValue = snapshot.value as! NSDictionary
            let text = snapshotValue["text"] as! String
            let sender = snapshotValue["from"] as! String
            let name = snapshotValue["name"] as! String
            let answerNumber = snapshotValue["answerNumber"] as! String
            print(snapshot.value!)
            if name != UserDefaults.standard.string(forKey: "username")! {
                if Int(self.myAnswerNumber) == self.enemyCallNumber {
                    let alert = UIAlertController(title: "判定", message: "あなたの負けです" , preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        self.dismiss(animated: true, completion: nil)
                        // OKの時のアクション
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }

                //相手が送ってきた時
                self.enemyAnswerNumber = Int(answerNumber)!
                if text.isNumeric() == true {
                self.enemyCallNumber = Int(text)!
                    print("自分の答えは\(self.myAnswerNumber)で、相手のcallは\(self.enemyCallNumber)")
                }else{
                    //自分が送った時
                    print("相手の答えは\(self.enemyAnswerNumber)で、自分のcallは\(self.myCallNumber)")
                }
                }else {
                    
                }
            let message = JSQMessage(senderId: sender, displayName: name, text: text)
            self.messages?.append(message!)
            self.finishSendingMessage()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //UserDefaults(呼び出し)
        let ud = UserDefaults.standard
        let username = ud.value(forKey: "username") as? String ?? "名無しさん"
        
        // クリーンアップツールバーの設定
        inputToolbar!.contentView!.leftBarButtonItem = nil
        // 新しいメッセージを受信するたびに下にスクロールする
        automaticallyScrollsToMostRecentMessage = true
        
        // 自分のsenderId, senderDisplayNameを設定
        self.senderId = uuidString
        self.senderDisplayName = username
        
        // 吹き出しの設定
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        // アバターの設定
        self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "woman.png")!, diameter: 64)
        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "man.png")!, diameter: 64)
        //メッセージデータの配列を初期化
        self.messages = []
        setupFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sendボタンが押された時に呼ばれるメソッド
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        //メッセージの送信処理を完了する(画面上にメッセージが表示される)
        self.finishReceivingMessage(animated: true)
        
        if text.isNumeric() == true {
            // 数
            self.myCallNumber = Int(text)!
            //high and low 判定
            if myCallNumber > enemyAnswerNumber {
                let alert = UIAlertController(title: "判定", message: "low" , preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // OKの時のアクション
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else if myCallNumber < enemyAnswerNumber {
                let alert = UIAlertController(title: "判定", message: "high", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // OKの時のアクション
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else if myCallNumber == enemyAnswerNumber {
                let alert = UIAlertController(title: "判定", message: "あたり！" , preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                    // OKの時のアクション
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else if Int(myAnswerNumber) == enemyCallNumber {
                let alert = UIAlertController(title: "判定", message: "あなたの負けです" , preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                    // OKの時のアクション
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }

        } else {
            // 文字
        }
        
        //firebaseにデータを送信、保存する
        let post1 = ["from": senderId, "name": senderDisplayName, "text": text, "answerNumber": myAnswerNumber]
        let post1Ref = ref.child("rooms").child(roomNumber).childByAutoId()
        post1Ref.setValue(post1)
        self.finishSendingMessage(animated: true)
        
        //キーボードを閉じる
        self.view.endEditing(true)
        
    }
    
    // アイテムごとに参照するメッセージデータを返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages![indexPath.item]
    }
    
    // アイテムごとのMessageBubble(背景)を返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    // アイテムごとにアバター画像を返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
    // アイテムの総数を返す
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages!.count
    }
    
    //画面遷移した直後の動作
    override func viewDidAppear(_ animated: Bool) {
        //秘密の番号の設定
        let alert = UIAlertController(title: "秘密の番号", message: "1桁の数字を入力して下さい", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.delegate = self
            textField.keyboardType = UIKeyboardType.numberPad // 数字のみの入力
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.myAnswerNumber = alert.textFields![0].text!
            // OKの時のアクション
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}


extension String {
    func isNumeric() -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[0-9]+").evaluate(with: self)
    }
}

