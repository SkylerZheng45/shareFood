//
//  SignUp.swift
//  OrderConveniently
//
//  Created by 郑思行 on 7/23/18.
//  Copyright © 2018 SkylerZheng. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUp: UIViewController {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var firstPassword: UITextField!
    @IBOutlet weak var secondPassword: UITextField!
    
    @IBAction func finishSignUp(_ sender: UIButton) {
        let em = emailAddress.text
        let fPass = firstPassword.text
        let sPass = secondPassword.text
        if let email = em, let fPassword = fPass, let sPassword = sPass{
            if email == "" || fPassword == "" || sPassword == ""{
                let passwordEmptyAlert = UIAlertController(title: "No Input", message: "Please fill out the spaces", preferredStyle: .alert)
                let passwordEmptyAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                passwordEmptyAlert.addAction(passwordEmptyAction)
                present(passwordEmptyAlert, animated: true, completion: nil)
                firstPassword.text = ""
                secondPassword.text = ""
            }else if fPassword != sPassword {
                let passwordMatchAlert = UIAlertController(title: "Passwords Don't Match", message: "Please reenter the passwords", preferredStyle: .alert)
                let passwordMatchAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                passwordMatchAlert.addAction(passwordMatchAction)
                present(passwordMatchAlert, animated: true, completion: nil)
                firstPassword.text = ""
                secondPassword.text = ""
            }else{
            
            Auth.auth().createUser(withEmail: email, password: fPassword) { (authResult, error) in
                if let user = authResult {
                    self.performSegue(withIdentifier: "showAfterSignUp", sender: nil)
                }else{
                    let signUpAlert = UIAlertController(title: "Sign Up Failed", message: error?.localizedDescription, preferredStyle: .alert)
                    let signUpAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    signUpAlert.addAction(signUpAction)
                    self.present(signUpAlert, animated: true, completion: nil)
                    self.firstPassword.text = ""
                    self.secondPassword.text = ""
                }
                }
                // ...
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
