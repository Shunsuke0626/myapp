//
//  LoginViewController.swift
//  Numeron
//
//  Created by 中村俊輔 on 2019/08/09.
//  Copyright © 2019 shunsuke. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var toEmail: UITextField!
    @IBOutlet weak var toPassword: UITextField!
    @IBOutlet weak var fromEmail: UILabel!
    @IBOutlet weak var fromUserId: UILabel!
    @IBOutlet weak var status: UILabel!
    let ud = UserDefaults.standard
    var auth: Auth!
    var handle: AuthStateDidChangeListenerHandle?
    var isLogIn: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.auth = Auth.auth()
        self.isLogIn = false
        toPassword.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handle = self.auth.addStateDidChangeListener { (auth, user) in
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.auth.removeStateDidChangeListener(self.handle!)
        let ud = UserDefaults.standard
        if ud.object(forKey: "email") != nil{
            self.performSegue(withIdentifier: "login", sender: nil)
        }
    }
    
    @IBAction func entry(_ sender: AnyObject) {
        self.auth.createUser(withEmail: self.toEmail.text!, password: self.toPassword.text!) { (authResult, error) in
            if error == nil {
                self.fromEmail.text = authResult?.user.email
                self.fromUserId.text = authResult?.user.uid
                self.isLogIn = true
                self.status.text = "登録が成功しました"
            } else {
                self.status.text = error!.localizedDescription
            }
        }
    }
    
    @IBAction func logIn(_ sender: AnyObject) {
        if self.isLogIn {
            self.status.text = "既にログインしています"
            self.performSegue(withIdentifier: "login", sender: nil)
            return
        }
        self.auth.signIn(withEmail: self.toEmail.text!, password: self.toPassword.text!) { (authResult, error) in
            if (error == nil) {
                self.fromEmail.text = authResult?.user.email
                self.fromUserId.text = authResult?.user.uid
                self.isLogIn = true
                self.status.text = "ログインに成功しました"
                let ud = UserDefaults.standard
                ud.set(authResult?.user.email, forKey: "email")
                ud.set(authResult?.user.uid, forKey: "password")
                ud.synchronize()
                //userdefaults保存
                self.performSegue(withIdentifier: "login", sender: nil)
            } else {
                self.status.text = error!.localizedDescription
            }
        }
    }
    
    @IBAction func logOut(_ sender: AnyObject) {
        if self.isLogIn == false {
            self.status.text = "ログインしていません"
            return
        }
        do {
            try self.auth.signOut()
            self.fromEmail.text = ""
            self.fromUserId.text = ""
            self.isLogIn = false
            self.status.text = "ログアウトに成功しました"
        } catch {
            self.status.text = "ログアウトに失敗しました"
        }
    }
    
}
