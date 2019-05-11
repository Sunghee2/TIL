//
//  SignUpVC.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 11/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var pwView: UIView!
    @IBOutlet weak var pwCheckView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var pwTF: UITextField!
    @IBOutlet weak var pwCheckTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIdView()
        setPwView()
        setPwCheckView()
        setemailView()
    }
    
    func setIdView() {
        self.idView.makeRounded(cornerRadius: nil)
        self.idView.setBorder(borderColor: UIColor.veryLightPinkTwo, borderWidth: 1.0)
    }
    
    func setPwView() {
        self.pwView.makeRounded(cornerRadius: nil)
        self.pwView.setBorder(borderColor: UIColor.veryLightPinkTwo, borderWidth: 1.0)
    }
    
    func setPwCheckView() {
        self.pwCheckView.makeRounded(cornerRadius: nil)
        self.pwCheckView.setBorder(borderColor: UIColor.veryLightPinkTwo, borderWidth: 1.0)
    }
    
    func setemailView() {
        self.emailView.makeRounded(cornerRadius: nil)
        self.emailView.setBorder(borderColor: UIColor.veryLightPinkTwo, borderWidth: 1.0)
    }
    
    func checkPassword(pw: String, pwCheck: String) -> Bool {
        return pw == pwCheck
    }
    
    
    @IBAction func signupBtnAction(_ sender: Any) {
        
        // 옵셔널 바인딩
        guard let id = idTF.text else { return }
        guard let pw = pwTF.text else { return }
        guard let pwCheck = pwCheckTF.text else { return }
        guard let name = nameTF.text else { return }
        
        if !checkPassword(pw: pw, pwCheck: pwCheck) { return }
        
        // 통신을 시도합니다.
        AuthService.shared.signup(id: id, password: pw, name: name) {
            (data) in

            switch (data.status) {
            case 201:
                self.dismiss(animated: true, completion: nil)
            case 400:
                self.simpleAlert(title: "회원가입 실패", message: self.gsno(data.message))

            case 600:
                self.simpleAlert(title: "회원가입 실패", message: self.gsno(data.message))

            default:
                break
            }
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
