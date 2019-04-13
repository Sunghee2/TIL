//
//  VC2.swift
//  ViewTransition-Practice
//
//  Created by Sunghee Lee on 13/04/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class VC2: UIViewController {
    
    @IBOutlet weak var receivedLabel: UILabel!
    
    // 전달받을 데이터를 저장할 변수. 전달 받을 때는 혹시나 모를 nil을 대비해야하므로 옵셔널 타입으로 선언해야
    var receivedData: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // viewDidload되었을 때 호출
        setup()
    }
    
    // 전달받은 데이터를 안전하게 옵셔널 바인딩하여 outlet 변수의 속성에 저장함.
    func setup() {
        if let transData = receivedData {
            receivedLabel.text = transData
        }
    }

    @IBAction func popAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true)
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
