//
//  WriteVC.swift
//  NetworkSeminar
//
//  Created by wookeon on 29/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class WriteVC: UIViewController {
    
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var uploadImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func uploadBtnAction(_ sender: Any) {
        
        guard let image = UIImage(named: "defaultImg") else { return }
        
        guard let content = commentView.text else { return }
        CommentService.shared.writeComment(epIdx: 9, content: content, cmtImg: image) {
            data in
            
            switch data {
            case .success(_):
                self.simpleAlert(title: "업로드 성공", message: "포스트맨으로 보자")
                break
            case .requestErr(let err):
                print(err)
                break
            case .pathErr:
                print("경로 에러")
                break
            case .serverErr:
                print("서버 에러")
                break
            case .networkFail:
                print("네트워크 에러")
                break
            }
        }
    }
}
