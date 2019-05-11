//
//  LoginVC.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 08/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var pwView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var pwTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIdView()
        setPwView()
        setLoginBtn()
    }

    func setIdView() {
        self.idView.setBorder(borderColor: UIColor.veryLightPinkTwo, borderWidth: 1.0)
        self.idView.makeRounded(cornerRadius: nil)
    }
    
    func setPwView() {
        self.pwView.setBorder(borderColor: UIColor.veryLightPinkTwo, borderWidth: 1.0)
        self.pwView.makeRounded(cornerRadius: nil)
    }
    
    func setLoginBtn() {
        self.loginBtn.makeRounded(cornerRadius: nil)
        self.loginBtn.dropShadow(color: UIColor.veryLightPink52, offSet: CGSize(width: 0.0, height: 3.0), opacity: 0.52, radius: 3)
    }
    
    
    // Login Button [touch up inside] Action
    @IBAction func loginBtnAction(_ sender: Any) {
        
        // 옵셔널 바인딩
        guard let id = idTF.text else { return }
        guard let pw = pwTF.text else { return }
        
        // 통신을 시도합니다.
        AuthService.shared.signin(id: id, password: pw) {
            (data) in

            switch (data.status) {
            case 201:
                // UserDefault 에 value, key 순으로 token 을 저장
                UserDefaults.standard.set(data.data, forKey: "refreshToken")
                
                // Storyboard 가 다른 ViewController 로 화면 전환을 하는 코드입니다.
                // 이동할 뷰가 Navigation Controller 에 연결된 경우엔 그 앞의 NavigationController 를 목적지로 선택합니다.
                let dvc = UIStoryboard(name: "Soptoon", bundle: nil).instantiateViewController(withIdentifier: "SoptoonNC") as! UINavigationController

                self.present(dvc, animated: true, completion: nil)

            case 400:
                self.simpleAlert(title: "로그인 실패", message: self.gsno(data.message))

            case 600:
                self.simpleAlert(title: "로그인 실패", message: self.gsno(data.message))

            default:
                break
            }


        }
    }
    
    @IBAction func unwindToLoginVC(_ sender: UIStoryboardSegue) {
        
    }
}

