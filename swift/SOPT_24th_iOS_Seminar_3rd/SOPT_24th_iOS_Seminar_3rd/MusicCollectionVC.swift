//
//  MusicCollectionVC.swift
//  SOPT_24th_iOS_Seminar_3rd
//
//  Created by wookeon on 27/04/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class MusicCollectionVC: UIViewController {
    
    // UICollectionView 의 Outlet 변수
    @IBOutlet var musicCollection: UICollectionView!
    
    // UICollectionView 에 들어가게 될 Music 모델 타입의 배열을 생성합니다.
    // Music 모델은 Music.swift 에 선언되어 있습니다.
    var musicList: [Music] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMusicData()
        
        // musicCollection 의 delegate 와 dataSource 의 위임자를 self 로 지정합니다.
        musicCollection.dataSource = self
        musicCollection.delegate = self
        
        // musicCollection 에 handleLongPreeGesture 를 추가합니다.
        musicCollection.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gesture:))))
    }
    
    /*
        gesture 를 구현하는 메소드입니다.
        마찬가지로 handleLongPreeGesture 는 이미 구현된 상태이고, 우리는 어떤 동작을 할 지 작성하면 됩니다.
     */
    @objc func handleLongPressGesture(gesture: UIGestureRecognizer){
        
        // gesture 가 발생한 좌표를 반환합니다.
        let location = gesture.location(in: self.musicCollection)
        
        // 해당 좌표에 musicCollection 의 item 이 존재한다면 indexPath 에 해당 item 의 index 를 반환합니다.
        guard let indexPath = musicCollection.indexPathForItem(at: location) else {return}
        
        // 해당하는 index 의 model 를 반환합니다.
        let item = musicList[indexPath.row]
        
        // alert 를 발생하는 메소드입니다.
        let alert = UIAlertController(title: "\(item.singer) - \(item.musicTitle)", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
            
            // musicList 배열에서 해당 모델을 제거합니다.
            self.musicList.remove(at: indexPath.item)
            
            // musicCollection 에서 해당하는 index 의 item 을 삭제합니다.
            self.musicCollection.deleteItems(at: [indexPath])
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        // alert 를 화면에 발생시킵니다.
        present(alert, animated: true, completion: nil)
    }
}

// UICollectionViewDataSource 를 채택합니다.
extension MusicCollectionVC: UICollectionViewDataSource {
    
    // UICollectionView 에 얼마나 많은 아이템을 담을 지 설정합니다.
    // 현재는 musicList 배열의 count 갯수 만큼 반환합니다.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return musicList.count
    }
    
    // 각 index 에 해당하는 셀에 데이터를 주입합니다.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCollectionViewCell", for: indexPath) as! MusicCollectionViewCell
        
        let music = musicList[indexPath.row]
        
        cell.albumImg.image = music.albumImg
        cell.musicTitle.text = music.musicTitle
        cell.singer.text = music.singer
        
        return cell
    }
}

// UICollectionViewDelegate 를 채택합니다.
extension MusicCollectionVC: UICollectionViewDelegate {
    
    /*
        didSelectItemAt 은 셀을 선택했을때 어떤 동작을 할 지 설정할 수 있습니다.
        여기서는 셀을 선택하면 그에 해당하는 MusicDetailVC 로 화면전환을 합니다.
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dvc = storyboard?.instantiateViewController(withIdentifier: "MusicDetailVC") as! MusicDetailVC
        
        let music = musicList[indexPath.row]
        
        dvc.albumImg = music.albumImg
        dvc.musicTitle = music.musicTitle
        dvc.singer = music.singer
        
        navigationController?.pushViewController(dvc, animated: true)
    }
}

/*
    UICollectionViewDelegateFlowLayout 을 채택합니다.
    바로 위의 UICollectionViewDelegate 내부의 메소드를 이 안에 넣어도 상관 없지만 가독성을 위해 분리했습니다.
 
    이 곳에서는 CollectionView 의 레이아웃을 관리합니다.
*/
extension MusicCollectionVC: UICollectionViewDelegateFlowLayout {
    
    // Collection View Cell 의 width, height 를 지정할 수 있습니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (view.frame.width - 45) / 2
        let height: CGFloat = (view.frame.width - 45) / 2 + 57
        
        return CGSize(width: width, height: height)
    }
    
    // minimumLineSpacingForSectionAt 은 수직 방향에서의 Spacing 을 의미합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    // minimumInteritemSpacingForSectionAt 은 수평 방향에서의 Spacing 을 의미합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    // insetForSectionAt 섹션 내부 여백을 말합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}

extension MusicCollectionVC {
    func setMusicData() {
        let music1 = Music(title: "삐삐", singer: "아이유", coverName: "album_iu")
        let music2 = Music(title: "가을 타나봐", singer: "바이브", coverName: "album_vibe")
        let music3 = Music(title: "고백", singer: "양다일", coverName: "album_yangdail")
        let music4 = Music(title: "하루도 그대를 사랑하지 않은 적이 없었다", singer: "임창정", coverName: "album_im")
        let music5 = Music(title: "Save (Feat. 팔로알토)", singer: "루피(Loopy)", coverName: "album_smtm7")
        let music6 = Music(title: "멋지게 인사하는 법 (Feat. 슬기)", singer: "Zion.T", coverName: "album_ziont")
        let music7 = Music(title: "IDOL", singer: "방탄소년단", coverName: "album_bts")
        let music8 = Music(title: "시간이 들겠지 (Feat. Colde)", singer: "로꼬", coverName: "album_loco")
        let music9 = Music(title: "모든 날, 모든 순간", singer: "폴킴", coverName: "album_paul")
        let music10 = Music(title: "Way Back Home", singer: "숀(SHAUN)", coverName: "album_shaun")
        
        // 생성한 musicList 배열에 Music 모델들을 저장합니다.
        musicList = [music1, music2, music3, music4, music5, music6, music7, music8, music9, music10]
    }
}
