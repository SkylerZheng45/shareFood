//
//  viewEditMenuViewController.swift
//  OrderConveniently
//
//  Created by 郑思行 on 7/29/18.
//  Copyright © 2018 SkylerZheng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class viewEditMenuViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    var resNameFromLastViewControllerForMenu:String?
    var menuItemsList = [String]()
    var numOfTables:Int?
    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    var selectedItem:String?
    let userOp = Auth.auth().currentUser
    var priceInTextField:Double?
    var caloriesInTextField:Double?
    
    
    @IBOutlet weak var itemSelectionLabel: UILabel!
    @IBOutlet weak var numOfTablesTextField: UITextField!
    @IBOutlet weak var viewEditPickerView: UIPickerView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var titleRes: UINavigationBar!
    
    @IBAction func deleteItem(_ sender: UIButton) {
        if let item = selectedItem, let user = userOp, let resName = resNameFromLastViewControllerForMenu{
            ref.child("data").child(user.uid).child(resName).child("menu").child(item).removeValue()
            
            let alertController = UIAlertController(title: "Item Removed Successfully", message: "\(item) was removed from the menu.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
        }else{
            let alertController = UIAlertController(title: "No Selection", message: "Please select an item to continue", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        print("update button pressed")
        if let text = priceTextField.text{
            if text.isEmpty{
                print("price text field is empty")
                priceTextField.text = "-1.3137"
            }
        }
        if let text = caloriesTextField.text{
            if text.isEmpty{
                print("calories text field is empty")
                caloriesTextField.text = "-1.3137"
            }
        }
        if caloriesInTextField == nil{
            caloriesInTextField = -1.3137
            print("caloriesInTextField -1.3137")
        }
        if priceInTextField == nil{
            priceInTextField = -1.3137
            print("priceInTextField -1.3137")
        }
        
        if let originalPrice = priceInTextField, let originalCalories = caloriesInTextField, let originalTableNum = numOfTables, let user = userOp, let resName = resNameFromLastViewControllerForMenu, let itemName = selectedItem, let currentTableNumString = numOfTablesTextField.text, let currentPriceString = priceTextField.text, let currentCaloriesString = caloriesTextField.text{
            if let currentTableNum = Int(currentTableNumString), let currentPrice = Double(currentPriceString), let currentCalories = Double(currentCaloriesString){
                var message = ""
                if String(originalTableNum) != numOfTablesTextField.text{
                    ref.child("data").child(user.uid).child(resName).child("numOfTables").setValue(currentTableNum)
                    message = message + "Number of tables was change from \(originalTableNum) to \(currentTableNum). "
                }
                if String(originalPrice) != priceTextField.text{
                   
                    if priceTextField.text == "-1.3137"{
                        ref.child("data").child(user.uid).child(resName).child("menu").child(itemName).child("price").removeValue()
                        message = message + "Value of price was removed"
                        priceTextField.text = ""
                    }else if originalPrice == -1.3137{
                        ref.child("data").child(user.uid).child(resName).child("menu").child(itemName).child("price").setValue(currentPrice)
                        message = message + "Price \(currentPrice) was added. "
                    }else{
                        ref.child("data").child(user.uid).child(resName).child("menu").child(itemName).child("price").setValue(currentPrice)
                        message = message + "Price was changed from \(originalPrice) to \(currentPrice). "
                    }
                }
                if String(originalCalories) != caloriesTextField.text{
                    if caloriesTextField.text == "-1.3137"{
                        ref.child("data").child(user.uid).child(resName).child("menu").child(itemName).child("calories").removeValue()
                        message = message + "Value of calories was removed"
                        caloriesTextField.text = ""
                    }else if originalPrice == -1.3137{
                        ref.child("data").child(user.uid).child(resName).child("menu").child(itemName).child("calories").setValue(currentCalories)
                        message = message + "Calories \(currentCalories) was added. "
                    }else{
                        ref.child("data").child(user.uid).child(resName).child("menu").child(itemName).child("calories").setValue(currentCalories)
                        message = message + "Calories was changed from \(originalCalories) to \(currentCalories). "
                    }
                }
                if priceTextField.text == "-1.3137"{
                    priceTextField.text = ""
                }
                if caloriesTextField.text == "-1.3137"
                {
                    caloriesTextField.text = ""
                }
                if message != ""{
                    let alertController = UIAlertController(title: "Information Changed Successfully", message: message, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                        present(alertController, animated: true, completion: nil)
                }else{
                    let alertController = UIAlertController(title: "No Information Change", message: "No information was changed during the process", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    present(alertController, animated: true, completion: nil)
                }
            
            }else{
                if priceTextField.text == "-1.3137"{
                    priceTextField.text = ""
                }
                if caloriesTextField.text == "-1.3137"{
                    caloriesTextField.text = ""
                }
                let alertController = UIAlertController(title: "Wrong Input", message: "Please input an integer for number of tables, and numbers for price and calories", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }
        }else{
            let alertController = UIAlertController(title: "No Selection", message: "Please select an item to continue", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return menuItemsList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return menuItemsList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = menuItemsList[row]
        itemSelectionLabel.text = "Selected \(menuItemsList[row])"
        
        ref = Database.database().reference()
        if let user = userOp,let res = resNameFromLastViewControllerForMenu{
        priceTextField.text = nil
        caloriesTextField.text = nil
        priceInTextField = nil
        caloriesInTextField = nil
            // getting the price
            databaseHandle = ref.child("data").child(user.uid).child(res).child("menu").child(menuItemsList[row]).child("price").observe(.value, with: { (snapshot) in
                if let value = snapshot.value as? Double{
                    self.priceTextField.text = String(value)
                    self.priceInTextField = value
                }
            })
            // getting the calories
            databaseHandle = ref.child("data").child(user.uid).child(res).child("menu").child(menuItemsList[row]).child("calories").observe(.value, with: { (snapshot) in
                if let value = snapshot.value as? Double{
                    self.caloriesTextField.text = String(value)
                    self.caloriesInTextField = value
                }
            })
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let res = resNameFromLastViewControllerForMenu{
            titleRes.topItem?.title = res
            print("viewEditMenu: \(res)")
        }else{
            print("No viewEditMenu")
        }
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        ref = Database.database().reference()
        if let user = userOp,let res = resNameFromLastViewControllerForMenu{
//            databaseHandle = ref.child("main_data").child("restaurants").child("menu").observe(.value, with: { (snapshot) in
//                if let num = snapshot.value as? Int{
//                    self.numOfTables = num
//                    self.numOfTablesTextField.text = String(num)
//                }else{
//                    print("No value for numOfTables")
//                }
//            })
            //anything added
            databaseHandle = ref.child("main_data").child("restaurants").child(res).child("menu").observe(.childAdded, with: { (snapshot) in
                self.menuItemsList.append(snapshot.key)
                print(snapshot.key)
                print("menuItemsList123: \(self.menuItemsList)")
                
                self.viewEditPickerView.reloadAllComponents()
            })
            
            //anything removed
            
            databaseHandle = ref.child("main_data").child("restaurants").child(res).child("menu").observe(.childRemoved, with: { (snapshot) in
                    if let position = self.menuItemsList.index(of: snapshot.key){
                        self.menuItemsList.remove(at: position)
                }
                self.viewEditPickerView.reloadAllComponents()
            })
            
            
        }
        print(menuItemsList)
        
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
