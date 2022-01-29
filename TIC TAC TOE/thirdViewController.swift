//
//  thirdViewController.swift
//  Project01
//
//  Created by Administrator on 09/07/2018.
//  Copyright © 2018 Usman. All rights reserved.
//

import UIKit

class thirdViewController: UIViewController {

   
    @IBOutlet var ImageView: UIImageView!
    @IBAction func Nextt(_ sender: Any) {
        performSegue(withIdentifier: "segue1", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.ImageView.image =  UIImage(named: "PIC")
        self.view.addSubview(ImageView)

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
