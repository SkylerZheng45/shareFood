//
//  ItemDetailsViewController.swift
//  OrderConveniently
//
//  Created by 郑思行 on 7/23/18.
//  Copyright © 2018 SkylerZheng. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ItemDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    let userOp = Auth.auth().currentUser
    var resList:[String] = []
    var chosenResName:String?
    var count = true
    
    @IBOutlet weak var resPickerView: UIPickerView!
    @IBOutlet weak var selectResLabel: UILabel!
    
    @IBAction func nextPageButton(_ sender: UIButton) {
        if let resName = chosenResName{
            performSegue(withIdentifier: "showRestaurants", sender: resName)
        }else{
            let selectionAlert = UIAlertController(title: "No Selection", message: "Please select a restaurant above", preferredStyle: .alert)
            let selectionAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            selectionAlert.addAction(selectionAction)
            present(selectionAlert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurants"{
            if let nextController = segue.destination as? viewEditMenuViewController{
                nextController.resNameFromLastViewControllerForMenu = sender as? String
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return resList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(resList[row])
        return resList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectResLabel.text = "chose \(resList[row])"
        chosenResName = resList[row]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if resList.isEmpty{
        //            let noResAlert = UIAlertController(title: "No Restaurant Found", message: "You don't own any restaurant, please go back and add a restaurant first", preferredStyle: .alert)
        //            let goBackAction = UIAlertAction(title: "OK", style: .default) { (goBackAction) in
        //                self.performSegue(withIdentifier: "noResGoBack", sender: nil)
        //            }
        //            noResAlert.addAction(goBackAction)
        //            self.present(noResAlert, animated: true, completion: nil)
        //        }
        //
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        //        if let user = userOp{
        
        //child("data").child(user.uid).child("resName").
        
        databaseHandle = ref.child("main_data").child("restaurants").observe(.childAdded, with: { (snapshot) in
            self.resList.append(snapshot.key)
            self.resPickerView.reloadAllComponents()
            if !self.resList.isEmpty && self.count == true{
                //Set Default Selection
                self.chosenResName = self.resList[0]
                self.selectResLabel.text = "chose \(self.resList[0])"
                self.count = false
                
            }
            //as? String
            //                if let resN = snapshot.value{
            //                    print("resName :!!!!\(resN)!!!")
            //                    //self.resList.append(resN)
            //                }else{
            //                    print("No snapshot")
            //                }
        })
        //        }else{
        //            print("No User")
        //        }
        print("resList1: \(resList)")
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}
