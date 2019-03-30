//
//  ViewController.swift
//  Navigation
//
//  Created by Sunghee Lee on 30/03/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // 네비게이션 바 유지되고 이전 버튼 생김
    @IBAction func showBtn(_ sender: Any) {
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "VC2") as? VC2 else {
            return
        }
        
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    // 바 없고 이전 버튼도 없이 여기 보이는 스크린 그대로 나옴
    @IBAction func PresentBtn(_ sender: Any) {
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "VC2") as? VC2 else {
            return
        }
        
        self.present(dvc, animated: true)
    }
}

