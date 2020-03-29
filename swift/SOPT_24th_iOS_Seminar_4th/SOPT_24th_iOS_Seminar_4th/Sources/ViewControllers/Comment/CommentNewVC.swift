//
//  CommentNewVC.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by Sunghee Lee on 25/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class CommentNewVC: UIViewController {

    var cmtIdx: Int?

    @IBOutlet var cancelBtn: UIBarButtonItem!
    @IBOutlet var okBtn: UIBarButtonItem!
    @IBOutlet var commentTF: UITextField!
    @IBOutlet var imageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
    }
    
    func setNavigationBar() {
        self.setBackBtn(color: UIColor.brownishGrey)
        self.setNavigationBarShadow()
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okBtnAction(_ sender: Any) {
    }
    
    
    @IBAction func imageBtnAction(_ sender: Any) {
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


