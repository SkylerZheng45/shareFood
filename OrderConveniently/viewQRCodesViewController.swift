//
//  viewQRCodesViewController.swift
//  OrderConveniently
//
//  Created by 郑思行 on 7/29/18.
//  Copyright © 2018 SkylerZheng. All rights reserved.
//

import UIKit

class viewQRCodesViewController: UIViewController {
    var resNameFromLastViewControllerForQR:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let res = resNameFromLastViewControllerForQR{
            print("viewQRCodes: \(res)")
        }else{
            print("No viewQRCodes")
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