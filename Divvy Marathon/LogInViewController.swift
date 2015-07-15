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
    @IBOutlet var signUpConfirmPassword: UITextField!
    @IBOutlet var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StyleHelper.initializeViewController(self)
    }
    
    @IBAction func onLogInButtonTapped(sender: UIButton) {
        let username = logInUsername.text
        let password = logInPassword.text
        let postString = "action=SignIn&username=\(username!)&password=\(password!)"
        
        DataManager.sendRequest(REQUEST_URL, postString: postString ) {
            response in
            
            var message = "Successfully signed in!"
            
            if let error = DataManager.error(response) {
                message = error
            } else {
                DataManager.saveUserInformation(response)
                self.dismissView()
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.messageLabel.text = message
            }
            
        }
        
    }
    
    @IBAction func onSignUpButtonTapped(sender: UIButton) {
        let username = signUpUsername.text!
        if let password = signUpPassword.text == signUpConfirmPassword.text! ? signUpPassword.text : nil {
            
            let postString = "action=SignUp&username=\(username)&password=\(password)"
            
            DataManager.sendRequest(REQUEST_URL, postString: postString ) {
                response in
                
                var message = "Successfully signed up!"
                
                if let error = DataManager.error(response) {
                    message = error
                } else {
                    DataManager.saveUserInformation(response)
                    self.dismissView()
                }
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.messageLabel.text = message
                }
            }
            
        } else {
            //messageLabel.text = "Passwords are not the same."
            return;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButtonTapped(sender: AnyObject) {
        dismissView()
    }
    
    func dismissView() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
            let secondPresentingVC = self.presentingViewController?.presentingViewController;
            secondPresentingVC?.dismissViewControllerAnimated(true, completion: {})
        })
    }

    

}
