//
//  VC1_1.swift
//  ViewTransition-Practice
//
//  Created by Sunghee Lee on 13/04/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class VC1_1: UIViewController {

    @IBOutlet weak var sendTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // Push button의 IBAction
    @IBAction func pushAction(_ sender: Any) {
        // VC2의 인스턴스를 생성함. 이 때 VC2 view controller의 스토리보드 아이디를 꼭 정의해야함.
        guard let dvc = storyboard?.instantiateViewController(withIdentifier:"VC2") as? VC2 else{ return }
        
        // ??는 옵셔널 nil 병합 연산자임.
        let check = !(sendTextField.text?.isEmpty ?? true)
        
        if check {
            dvc.receivedData = sendTextField.text
        }
        
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    
    @IBAction func presentAction(_ sender: Any) {
        if let menuScreen = self.storyboard?.instantiateViewController(withIdentifier: "VC2"){
            self.present(menuScreen, animated: true)
        }
    }
    /*
     @IBAction func present(_ sender: Any) {
     }
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
