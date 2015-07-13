//
//  LogInViewController.swift
//  Divvy Marathon
//
//  Created by Julianne Knott on 7/13/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    
    @IBOutlet weak var logInUsername: UITextField!
    @IBOutlet weak var logInPassword: UITextField!
    @IBOutlet weak var signUpUsername: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let username = logInUsername.text
        let password = logInUsername.text
        print ("\(username)'s password is \(password)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
