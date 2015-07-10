//
//  ViewController.swift
//  Divvy Marathon
//
//  Created by Jack Cable on 7/10/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var numMinutes = 0
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh"
        let hrsStr = dateFormatter.stringFromDate(datePicker.date)
        dateFormatter.dateFormat = "mm"
        let hours = Int(hrsStr)
        let minsStr = dateFormatter.stringFromDate(datePicker.date)
        let minutes = Int(minsStr)
        numMinutes = hours! * 60 + minutes!
    }

    @IBAction func onTappedGoButton(sender: UIButton) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

