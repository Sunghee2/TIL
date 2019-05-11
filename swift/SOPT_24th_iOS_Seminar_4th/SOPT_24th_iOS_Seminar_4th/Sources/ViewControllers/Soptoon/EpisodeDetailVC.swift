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

    @IBOutlet weak var episodeDetailCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       setBackBtn(color: UIColor.brownishGrey)
        episodeDetailCV.delegate = self
        episodeDetailCV.dataSource = self
        
//        self.view.addSubview(UIView(frame: CGRect))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let idx = epIdx else {return}
        
        EpisodeDetailService.shared.getEpisodeDetail(epIdx: idx) {
            [weak self]
            (data) in
            
            guard let `self` = self else { return }
            
//            self.episodeList = list
//            self.episodeTV.reloadData()
        }
    }
}

extension EpisodeDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeDetailCVC", for: indexPath) as! EpisodeDetailCVC
        
        
        
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
