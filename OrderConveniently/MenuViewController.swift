//
//  MenuViewController.swift
//  OrderConveniently
//
//  Created by 郑思行 on 7/20/18.
//  Copyright © 2018 SkylerZheng. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MenuViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    let userOp = Auth.auth().currentUser
    var itemList:[String] = ["Empty"]
    var resName:String?
    var ref: DatabaseReference!
    
    @IBOutlet weak var numOfTables: UITextField!
    
    @IBOutlet weak var restaurantName: UITextField!
    
    @IBOutlet weak var menuItemName: UITextField!
    
    @IBOutlet weak var itemPickerView: UIPickerView!
    
    // remember to add the agorithm that deletes duplicated items!!!!!!!!!!!!!!!!!
    func deleteDuplicatesList(listOfItems: [String]) -> [String]{
        let items = Array(Set(listOfItems))
        
        if items.count != listOfItems.count{
            let duplicateAlert = UIAlertController(title: "Duplicate Items", message: "The system automatically deleted duplicate items in the menu", preferredStyle: .alert)
            let duplicateAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            duplicateAlert.addAction(duplicateAction)
            present(duplicateAlert, animated: true, completion: nil)
        }
        return items
    }
    //save and to qr codes
    @IBAction func saveAndToQRCodes(_ sender: UIButton) {
        print("saved the menu")
        
        itemList = deleteDuplicatesList(listOfItems: itemList)
        
        if let restaurantName = restaurantName.text{
            if restaurantName == ""{
                let resAlert = UIAlertController(title: "No Input", message: "Please Input the Name of the Restaurant", preferredStyle: .alert)
                let resAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                resAlert.addAction(resAction)
                present(resAlert, animated: true, completion: nil)
            }
            else{
                resName = restaurantName
                 print("\(resName!)   \(itemList)")
                if let user = userOp, let resNam = resName, let tablesNum = numOfTables.text{
                     if let theNum = Int(tablesNum){
                        if theNum > 0{
                            self.ref.child("data").child(user.uid).child(resNam).child("resName").setValue(resNam)
                            self.ref.child("data").child(user.uid).child(resNam).child("numOfTables").setValue(theNum)

                            for item in itemList{
                                //write on the database
                            self.ref.child("data").child(user.uid).child(resNam).child("menu").child(item).child("name").setValue(item)
                        
                            }
                            var items = itemList
                            items.append(resNam)
                            print(items)
                            performSegue(withIdentifier: "showItemDetails", sender: items)
                        }else{
                            let pageAlert = UIAlertController(title: "Error", message: "Please input a positive integer for the number of tables", preferredStyle: .alert)
                            let pageAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            pageAlert.addAction(pageAction)
                            present(pageAlert, animated: true, completion: nil)
                        }
                     }else{
                        let pageAlert = UIAlertController(title: "Error", message: "Please input an integer for the number of tables", preferredStyle: .alert)
                        let pageAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        pageAlert.addAction(pageAction)
                        present(pageAlert, animated: true, completion: nil)
                    }
                    
                }else{
                    let pageAlert = UIAlertController(title: "Error", message: "An error has occurred", preferredStyle: .alert)
                    let pageAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    pageAlert.addAction(pageAction)
                    present(pageAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemDetails"{
            if let itemDetails = segue.destination as? ItemDetailsViewController{
                //itemDetails.itemListFromMenu = sender as? [String]
                print("performed preparation")
            }
        }
    }
    
    // PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1). \(itemList[row])"
    }
    
    //Button "Add" for Menu Items
    @IBAction func addMenuItems(_ sender: UIButton) {
        if let menuItem = menuItemName.text{
            if menuItem == ""{
                let itemAlert = UIAlertController(title: "No Input", message: "Please Input the Name of the Item", preferredStyle: .alert)
                let itemAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                itemAlert.addAction(itemAction)
                present(itemAlert, animated: true, completion: nil)
            }
            else{
                if itemList[0] == "Empty"{
                    itemList[0] = menuItem
                }else{
                    itemList.append(menuItem)
                }
                itemPickerView.reloadAllComponents()
                menuItemName.text = ""
               
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         ref = Database.database().reference()
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
