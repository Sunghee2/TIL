//
//  ViewController.swift
//  helloSOPT
//
//  Created by Sunghee Lee on 30/03/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func sayHello(_ sender: Any) {
        self.titleLabel.text = "SOPT"
    }
}

