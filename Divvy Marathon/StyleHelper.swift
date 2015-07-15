//
//  StyleHelper.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/12/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

/**

A class to help style pages the color we want

**/

import UIKit

let TINT_COLOR = UIColor(red: 0.271, green: 0.772, blue: 0.886, alpha: 1)

class StyleHelper: NSObject {
    /** 
        makes the viewcontroller look pretty
    **/
    class func initializeViewController(viewController: UIViewController) {
        if let navigationController = viewController.navigationController {
            navigationController.navigationBar.barTintColor = TINT_COLOR
            navigationController.toolbar.barTintColor = TINT_COLOR
            navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
            navigationController.navigationBar.tintColor = UIColor.whiteColor()
        }
    }
}
