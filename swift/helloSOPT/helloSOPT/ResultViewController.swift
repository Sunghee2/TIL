//
//  ResultViewController.swift
//  helloSOPT
//
//  Created by Sunghee Lee on 30/03/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    // 화면에 값을 표시하는데 사용할 Label
    @IBOutlet weak var resultEmail: UILabel! // 이메일
    @IBOutlet weak var resultUpdate: UILabel! // 자동갱신 여부
    @IBOutlet weak var resultInterval: UILabel! // 갱신주기
    
    // email 값을 받을 변수
    var paramEmail: String = ""
    // update 값을 받을 변수
    var paramUpdate: Bool = false
    // Interval 값을 받을 변수
    var paramInterval: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resultEmail.text = paramEmail
        self.resultUpdate.text = (self.paramUpdate == true ? "자동갱신" : "자동갱신 안함")
        self.resultInterval.text = "\(Int(paramInterval)) 분 마다 갱신"
    }
    
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true)
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
