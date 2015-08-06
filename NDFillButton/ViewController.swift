//
//  ViewController.swift
//  NDFillButton
//
//  Created by Neil Dwyer on 7/28/15.
//  Copyright (c) 2015 Neil Dwyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: NDFillButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        button.setActive(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        button.toggle()
    }
}

