//
//  VC3.swift
//  ViewTransition-Practice
//
//  Created by Sunghee Lee on 13/04/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class VC3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func unwindAction(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
