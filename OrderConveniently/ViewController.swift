//
//  ViewController.swift
//  OrderConveniently
//
//  Created by 郑思行 on 7/20/18.
//  Copyright © 2018 SkylerZheng. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {

    var ref: DatabaseReference!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassWord: UITextField!
    
    @IBAction func loginButton(_ sender: UIButton) {
        if let email = userName.text, let password = userPassWord.text{
            if email == "" || password == ""{
                let logInAlert = UIAlertController(title: "No Input", message: "Please fill out the spaces", preferredStyle: .alert)
                let logInAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                logInAlert.addAction(logInAction)
                present(logInAlert, animated: true, completion: nil)
            }else{
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if let u = user{
                        self.performSegue(withIdentifier: "showAfterLogIn", sender: nil)
                    }else{
                        let signUpAlert = UIAlertController(title: "Log In Failed", message: error?.localizedDescription, preferredStyle: .alert)
                        let signUpAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        signUpAlert.addAction(signUpAction)
                        self.present(signUpAlert, animated: true, completion: nil)
                        self.userPassWord.text = ""
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print("app loaded")
        // Do any additional setup after loading the view, typically from a nib.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

