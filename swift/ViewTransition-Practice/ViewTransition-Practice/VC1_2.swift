//
//  VC1_2.swift
//  ViewTransition-Practice
//
//  Created by Sunghee Lee on 13/04/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class VC1_2: UIViewController {

    @IBOutlet weak var sendTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func menualShowAction(_ sender: Any) {
        performSegue(withIdentifier: "menualShow", sender: self)
    }
    
    
    @IBAction func menualPresentAction(_ sender: Any) {
        performSegue(withIdentifier: "menualPresent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "actionShow" {
//            let sendData = sendTextField.text
//            let dvc = segue.destination as! VC2
//            dvc.receivedData = sendData
        switch segue.identifier {
        case "actionShow":
            let sendData = sendTextField.text
            let dvc = segue.destination as! VC2
            dvc.receivedData = sendData
        case "actionPresent":
            let sendData = sendTextField.text
            let dvc = segue.destination as! VC2
            dvc.receivedData = sendData
        case "menualShow":
            let sendData = sendTextField.text
            let dvc = segue.destination as! VC2
            dvc.receivedData = sendData
        case "menualPresent":
            let sendData = sendTextField.text
            let dvc = segue.destination as! VC2
            dvc.receivedData = sendData
        default:
            break
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {
    }

}
