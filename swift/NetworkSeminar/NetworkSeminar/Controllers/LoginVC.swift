//
//  LoginVC.swift
//  NetworkSeminar
//
//  Created by wookeon on 05/06/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var pwView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var stackViewCenterY: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setViews()
        initGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    func setViews() {
        
        // 모서리를 둥글게 처리
        idView.makeRounded(cornerRadius: nil)
        pwView.makeRounded(cornerRadius: nil)
        loginBtn.makeRounded(cornerRadius: nil)
        
        // 테두리 만들기
        idView.setBorder(borderColor: UIColor.veryLightPinkTwo, borderWidth: 0.5)
        pwView.setBorder(borderColor: UIColor.veryLightPinkTwo, borderWidth: 0.5)
        
        // 그림자 만들기
        loginBtn.dropShadow(color: UIColor.veryLightPink52, offSet: CGSize(width: 0, height: 3), opacity: 1.0, radius: 3)
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        guard let id = idTextField.text else {return}
        guard let pw = pwTextField.text else {return}
        
        AuthService.shared.login(id, pw) {
            data in
            
            switch data {
            case .success(let token):
                UserDefaults.standard.set(token, forKey: "token")
                
                let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNC") as! UINavigationController
                
                self.present(dvc, animated: true)
                
                break
            case .requestErr(let err):
                self.simpleAlert(title: "로그인 실패", message: err as! String)
                break
            case .pathErr:
                // 대체로 경로를 잘못 쓴 경우입니다.
                // 오타를 확인해보세요.
                print("경로 에러")
                break
            case .serverErr:
                // 서버의 문제인 경우입니다.
                // 여기에서 동작할 행동을 정의해주시면 됩니다.
                print("서버 에러")
                break
            case .networkFail:
                self.simpleAlert(title: "통신 실패", message: "네트워크 상태를 확인하세요.")
                break
            }
        }
    }
}

extension LoginVC: UIGestureRecognizerDelegate {
    
    func initGestureRecognizer() {
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        view.addGestureRecognizer(textFieldTap)
    }
    
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) {
        self.idTextField.resignFirstResponder()
        self.pwTextField.resignFirstResponder()
    }
    
    
    func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: idTextField))! || (touch.view?.isDescendant(of: pwTextField))! {
            
            return false
        }
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        // 각 단말기마다 다른 키보드 높이를 가져오는 것
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight: CGFloat
        
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        // 키보드가 올라오면서 로그인 창이 위로 올라감.
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            
            self.logoImgView.alpha = 0
            self.stackViewCenterY.constant = -keyboardHeight/2
            
        })
        
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        // 키보드가 내려가면서 로그인 창이 원래 자리로 돌아옴
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            
            self.logoImgView.alpha = 1
            self.stackViewCenterY.constant = 0
            
        })
        
        self.view.layoutIfNeeded()
    }
    
    // 관찰자 패턴 : 키보드를 보고있다가 변경될 때 update하는 것.
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
