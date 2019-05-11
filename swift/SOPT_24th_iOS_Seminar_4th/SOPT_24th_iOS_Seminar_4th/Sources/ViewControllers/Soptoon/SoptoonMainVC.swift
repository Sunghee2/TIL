//
//  SoptoonMainVC.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by wookeon on 09/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class SoptoonMainVC: UIViewController {

    @IBOutlet weak var soptoonCV: UICollectionView!
    
    
    @IBOutlet weak var popularBtn: UIButton!
    @IBOutlet weak var newBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    
    var soptoonList = [Soptoon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarTitle()
        setTypeBtnBorder()
        registerCVC()
        soptoonCV.delegate = self
        soptoonCV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
         api 문서에 보면
         flag 1: 인기
         flag 2: 신작
         flag 3: 완결
         */
        getSoptoon(flag: 1)
    }
    
    func setNavigationBarTitle() {        
        let image = UIImage(named: "naviLogoImg")
        navigationItem.titleView = UIImageView(image: image)
    }
    
    func setTypeBtnBorder() {
        popularBtn.setBorder(borderColor: UIColor.veryLightPinkThree, borderWidth: 1.0)
        newBtn.setBorder(borderColor: UIColor.veryLightPinkThree, borderWidth: 1.0)
        endBtn.setBorder(borderColor: UIColor.veryLightPinkThree, borderWidth: 1.0)
    }
    
    func registerCVC() {
        
        /*
         xib 로 만들어진 UICollectionViewCell 을 사용하기 위해서는 아래와 같은 절차가 필요합니다.
         nibName 에는 *.xib 의 이름을 입력합니다.
         forCellWithReuseIdentifier 에는 *.xib 의 reuseIdentifier 를 입력합니다.
        */
        let nibName = UINib(nibName: "SoptoonCVC", bundle: nil)
        soptoonCV.register(nibName, forCellWithReuseIdentifier: "SoptoonCVC")
    }
    
    func getSoptoon(flag: Int) {
        MainService.shared.getSoptoon(flag: flag) {
            /*
             clusure 의 선언부에 [weak self] 를 명시해주고
             self 가 사용되는 곳에 self 를 옵셔널로 사용해주면
             strong reference cycle 을 피할 수 있다.
             
             어떠한 상황에서 해당 issue 가 발생하는 지 모르겠다면
             closure 내부에서 self 를 사용하는 경우
             [weak self] param in 을 항상 명시해주는 습관을 기르면 좋을 것이다.
            */
            [weak self]
            (data) in
            
            /*
             예약어의 경우 변수 이름을 grave accent 로 감싸주면
             변수로써 사용할 수 있다.
             
             이 곳에서 self 를 옵셔널로 사용해준 모습이다.
            */
            guard let `self` = self else { return }
            
            self.soptoonList = data
            
            // soptoonCV 의 데이터를 reload 합니다.
            self.soptoonCV.reloadData()
        }
    }
    
    @IBAction func typeBtnAction(_ sender: UIButton) {
        
        if !sender.isSelected {
            sender.isSelected = true
        }
        
        switch sender.currentTitle {
        case "인기":
            getSoptoon(flag: 1)
            newBtn.isSelected = false
            endBtn.isSelected = false
        case "신작":
            getSoptoon(flag: 2)
            popularBtn.isSelected = false
            endBtn.isSelected = false
        case "완결":
            getSoptoon(flag: 3)
            popularBtn.isSelected = false
            newBtn.isSelected = false
        default:
            break
        }
        
        popularBtn.isSelected ? (popularBtn.backgroundColor = UIColor.maize) : (popularBtn.backgroundColor = UIColor.white)
        newBtn.isSelected ? (newBtn.backgroundColor = UIColor.maize) : (newBtn.backgroundColor = UIColor.white)
        endBtn.isSelected ? (endBtn.backgroundColor = UIColor.maize) : (endBtn.backgroundColor = UIColor.white)
    }
}

extension SoptoonMainVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return soptoonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoptoonCVC", for: indexPath) as! SoptoonCVC

        let soptoon = soptoonList[indexPath.row]
        
        cell.thumbImg.imageFromUrl(gsno(soptoon.thumbnail), defaultImgPath: "thumbnailImg")
        cell.titleLabel.text = soptoon.title
        cell.authorLabel.text = soptoon.author
        
        return cell
    }
}

extension SoptoonMainVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dvc = storyboard?.instantiateViewController(withIdentifier: "EpisodeVC") as! EpisodeVC
        
        dvc.wtIdx = soptoonList[indexPath.row].idx
        dvc.navTitle = soptoonList[indexPath.row].title
        
        navigationController?.pushViewController(dvc, animated: true)
    }
}

extension SoptoonMainVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (view.frame.width) / 3
        let height: CGFloat = (width) + 44
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
