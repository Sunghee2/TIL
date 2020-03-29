//
//  MainVC.swift
//  NetworkSeminar
//
//  Created by wookeon on 05/06/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var webtoonCV: UICollectionView!
    
    var webtoonList: [Webtoon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webtoonCV.delegate = self
        webtoonCV.dataSource = self

        getWebtton(flag: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getWebtton(flag: 1)
    }

    
    func getWebtton(flag: Int) {
        
        WebtoonService.shared.getWebtoon(flag: flag) {
            [weak self]
            data in
            
            guard let `self` = self else { return }
            
            switch data {
            case .success(let res):
                
                self.webtoonList = res as! [Webtoon]
                self.webtoonCV.reloadData()
                
                break
            case .requestErr(let err):
                print(".requestErr(\(err))")
                break
            case .pathErr:
                // 대체로 경로를 잘못 쓴 경우입니다.
                // 오타를 확인해보세요.
                print("경로 에러")
                break
            case .serverErr:
                // 서버의 문제인 경우입니다.
                // 여기에서 동작할 행동을 정의해주시면 됩니다.
                print("서버 에러")
                break
            case .networkFail:
                self.simpleAlert(title: "통신 실패", message: "네트워크 상태를 확인하세요.")
                break
            }
        }
    }
    
    
    @IBAction func flagBtnAction(_ sender: UIButton) {
        
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
        }
        
        switch sender.titleLabel?.text {
        case "인기":
            getWebtton(flag: 1)
            
            break
        case "신작":
            getWebtton(flag: 2)
            break
        case "완결":
            getWebtton(flag: 3)
            break
        default:
            getWebtton(flag: 1)
            break
        }
    }
}


// UICollectionViewDataSource 를 채택합니다.
extension MainVC: UICollectionViewDataSource {
    
    // UICollectionView 에 얼마나 많은 아이템을 담을 지 설정합니다.
    // 현재는 musicList 배열의 count 갯수 만큼 반환합니다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return webtoonList.count
    }
    
    // 각 index 에 해당하는 셀에 데이터를 주입합니다.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebtoonCVC", for: indexPath) as! WebtoonCVC
        
        let webtoon = webtoonList[indexPath.row]
        
        cell.thumbnail.imageFromUrl(webtoon.thumnail, defaultImgPath: "thumbnailImg")
        cell.title.text = webtoon.title
        cell.author.text = webtoon.name
        
        return cell
    }
}

/*
 UICollectionViewDelegateFlowLayout 을 채택합니다.
 바로 위의 UICollectionViewDelegate 내부의 메소드를 이 안에 넣어도 상관 없지만 가독성을 위해 분리했습니다.
 
 이 곳에서는 CollectionView 의 레이아웃을 관리합니다.
 */
extension MainVC: UICollectionViewDelegateFlowLayout {
    
    // Collection View Cell 의 width, height 를 지정할 수 있습니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (view.frame.width) / 3
        let height: CGFloat = width + 44
        
        return CGSize(width: width, height: height)
    }
    
    // minimumLineSpacingForSectionAt 은 수직 방향에서의 Spacing 을 의미합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    // minimumInteritemSpacingForSectionAt 은 수평 방향에서의 Spacing 을 의미합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    // insetForSectionAt 섹션 내부 여백을 말합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
