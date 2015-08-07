//
//  TabBarController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 8/2/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        selectedIndex = 1
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent //white status bar
        //tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        //tabBarController?.tabBar.barTintColor = TINT_COLOR

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
