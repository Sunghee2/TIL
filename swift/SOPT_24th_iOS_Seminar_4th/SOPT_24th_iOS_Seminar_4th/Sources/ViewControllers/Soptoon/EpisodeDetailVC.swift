//
//  EpisodeDetailVC.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class EpisodeDetailVC: UIViewController {
    
    var epIdx: Int?
    var episodeImgs = [String]()
    var epInfo: EpisodeInfo?

    @IBOutlet weak var episodeDetailCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setNavigationBar()
        registerCVC()
        episodeDetailCV.delegate = self
        episodeDetailCV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let idx = epIdx else {return}
        getEpisodeDetail(epIdx: idx)
    }
    
    func getEpisodeDetail(epIdx: Int) {
        EpisodeDetailService.shared.getEpisodeDetail(epIdx: epIdx) {
            [weak self]
            (data) in
            
            guard let `self` = self else { return }
            guard let data = data.data else { return }
            
            self.episodeImgs = data.epImgs!
            self.epInfo = data.epInfo!
            self.episodeDetailCV.reloadData()
            
            let chapter: Int = (self.epInfo?.chapter)!
            let title: String = (self.epInfo?.title)!
            
            self.navigationItem.title = "\(chapter)화. \(title)"
        }
    }
    
    func setNavigationBar() {
        self.setBackBtn(color: UIColor.brownishGrey)
        self.setCommentBtn(color: UIColor.yellow)
        self.setNavigationBarShadow()
    }
    
    func registerCVC() {
        let nibName = UINib(nibName: "EpisodeDetailCVC", bundle: nil)
        episodeDetailCV.register(nibName, forCellWithReuseIdentifier: "EpisodeDetailCVC")
    }
}



extension EpisodeDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return episodeImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeDetailCVC", for: indexPath) as! EpisodeDetailCVC
        
        let episodeImg = episodeImgs[indexPath.row]
        cell.EpisodeDeailImg.imageFromUrl(episodeImg, defaultImgPath: "logoImg")
        
        return cell
    }
}

extension EpisodeDetailVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (view.frame.width) - 34
        let height: CGFloat = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        
        return UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
    }
}
