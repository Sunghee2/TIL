//
//  MusicDetailVC.swift
//  SOPT_24th_iOS_Seminar_3rd
//
//  Created by wookeon on 26/04/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class MusicDetailVC: UIViewController {
    
    // TableView. CollectionView 에서 선택한 Cell 의 정보를 담아둘 변수
    var albumImg: UIImage?
    var musicTitle: String?
    var singer: String?
    
    // MusicDetailVC 의 인터페이스 빌더 상의 Outlet 변수들
    @IBOutlet var albumImgView: UIImageView!
    @IBOutlet var musicTitleLabel: UILabel!
    @IBOutlet var singerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setContents()
        setAlbumImgView()
    }
    
    func setContents() {
        albumImgView.image = albumImg
        musicTitleLabel.text = musicTitle
        singerLabel.text = singer
    }
    
    func setAlbumImgView() {
        albumImgView.layer.cornerRadius = 5
        albumImgView.layer.masksToBounds = true
    }
    
    
    @IBAction func btn(_ sender: Any) {
        dismiss()
    }
}
