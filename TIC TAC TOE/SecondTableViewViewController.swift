//
//  SecondTableViewViewController.swift
//  Project01
//
//  Created by Administrator on 09/07/2018.
//  Copyright © 2018 Usman. All rights reserved.
//

import UIKit
var name = ""
class SecondTableViewViewController: UIViewController {

    
    @IBOutlet weak var tictactoe: UILabel!
    
    @IBOutlet weak var EnterNameee: UILabel!
    
    @IBOutlet weak var text: UITextField!
    @IBAction func Save(_ sender: Any)
    {
        if(text.text != "")
        {
            name = text.text!
            performSegue(withIdentifier: "segue", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
