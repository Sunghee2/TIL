//
//  VC1.swift
//  helloSOPT
//
//  Created by Sunghee Lee on 30/03/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class VC1: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var isUpdate: UISwitch!
    @IBOutlet weak var interval: UIStepper!
    @IBOutlet weak var isUpdateText: UILabel!
    @IBOutlet weak var intervalText: UILabel!
    
    /**
     UISwitch타입으로 지정해주면 바로 isOn 지정 가능
     만약 Any type으로 지정했으면 아래 주석과 같이 추가하면 됨.
     **/
    @IBAction func onSwitch(_ sender: UISwitch) {
        
//        1) 옵셔널 캐스팅 - UISwitch 아니면 리턴해서 끝남
//        guard let obj = sender as? UISwitch else {
//            return
//        }
//        
//        2) 강제 캐스팅 - 강제로 UISwitch로 캐스팅
//        let obj = sender as! UISwitch
        
        
        if(sender.isOn == true) {
            self.isUpdateText.text = "갱신함"
        } else {
            self.isUpdateText.text = "갱신하지 않음"
        }
    }

    // 갱신주기가 바뀔 때마다 호출되는 메소드
    @IBAction func onStepper(_ sender: UIStepper) {
        let value = Int(sender.value)
        self.intervalText.text = "\(value) 분 마다"
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        // VC2의 인스턴스 생성
        guard let rvc = self.storyboard?.instantiateViewController(withIdentifier: "RVC") as? ResultViewController else {
            return
        }
        
        // 값 전달
        rvc.paramEmail = self.email.text! // 이메일
        rvc.paramUpdate = self.isUpdate.isOn // 자동갱신 여부
        rvc.paramInterval = self.interval.value // 갱신주기
        
        // 화면 이동
        self.present(rvc, animated: true)
    }
}
