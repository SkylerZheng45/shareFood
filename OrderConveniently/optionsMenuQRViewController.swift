//
//  optionsMenuQRViewController.swift
//  OrderConveniently
//
//  Created by 郑思行 on 7/26/18.
//  Copyright © 2018 SkylerZheng. All rights reserved.
//

import UIKit

class optionsMenuQRViewController: UIViewController {

    var resNameFromLastController:String?
    
    @IBOutlet weak var resNameLabel: UILabel!
    
    @IBAction func viewEditMenuButton(_ sender: UIButton) {
        if let resName = resNameFromLastController{
            performSegue(withIdentifier: "viewEditMenu", sender: resName)
        }else{
            print("error1")
        }
        
    }
    
    @IBAction func viewQRCodesButton(_ sender: UIButton) {
        if let resName = resNameFromLastController{
            performSegue(withIdentifier: "viewQRCodes", sender: resName)
        }else{
            print("error1")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewEditMenu"{
            if let viewEdit = segue.destination as? viewEditMenuViewController{
                viewEdit.resNameFromLastViewControllerForMenu = sender as? String
            }
        }else if segue.identifier == "viewQRCodes"{
            if let viewEdit = segue.destination as? viewQRCodesViewController{
                viewEdit.resNameFromLastViewControllerForQR = sender as? String
            }
        }else{
            print("error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let res = resNameFromLastController{
            print(res)
            resNameLabel.text = res
        }else{
            print("nope")
        }
       
        // Do any additional setup after loading the view.
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
