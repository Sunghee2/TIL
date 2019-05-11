//
//  EpisodeVC.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class EpisodeVC: UIViewController {
    
    var episodeList = [EpisodeList]()
    var wtIdx: Int?
    var navTitle: String?

    @IBOutlet weak var episodeTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setNavigationBar()
        registerTVC()
        episodeTV.delegate = self
        episodeTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let idx = wtIdx else { return }
        
        EpisodeService.shared.getEpisodeList(wtIdx: idx) {
            [weak self]
            (data) in
            
            guard let `self` = self else { return }
            
            guard let list = data.data?.list else { return }
            
            self.episodeList = list
            self.episodeTV.reloadData()
        }
    }
    
    func setNavigationBar() {
        self.navigationItem.title = navTitle
        self.setBackBtn(color: UIColor.brownishGrey)
        self.setNavigationBarShadow()
    }
    
    func registerTVC() {
        
        /*
         xib 로 만들어진 UITableViewCell 을 사용하기 위해서는 아래와 같은 절차가 필요합니다.
         nibName 에는 *.xib 의 이름을 입력합니다.
         forCellReuseIdentifier 에는 *.xib 의 reuseIdentifier 를 입력합니다.
         */
        let nibName = UINib(nibName: "EpisodeTVC", bundle: nil)
        episodeTV.register(nibName, forCellReuseIdentifier: "EpisodeTVC")
    }
}

extension EpisodeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = episodeTV.dequeueReusableCell(withIdentifier: "EpisodeTVC") as! EpisodeTVC
        
        let episode = episodeList[indexPath.row]
        
        cell.thumbnailImg.imageFromUrl(gsno(episode.thumbnail), defaultImgPath: "thumbnailImg")
        cell.titleLabel.text = episode.title
        
        let largeNumber = gino(episode.hits)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: largeNumber))
        
        cell.hitsLabel.text = "조회수 \(gsno(formattedNumber)) 회"
        
        return cell
    }
}

// UITableViewDelegate 를 채택합니다.
extension EpisodeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let dvc = storyboard?.instantiateViewController(withIdentifier: "EpisodeDetailVC") as! EpisodeDetailVC
    
//        let episode = episodeList[indexPath.row]
        
        
        navigationController?.pushViewController(dvc, animated: true)
    }
}
