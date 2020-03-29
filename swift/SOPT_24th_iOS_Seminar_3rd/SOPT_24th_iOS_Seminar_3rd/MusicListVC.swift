//
//  MusicListVC.swift
//  SOPT_24th_iOS_Seminar_3rd
//
//  Created by wookeon on 26/04/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

class MusicListVC: UIViewController {
    
    
    // UITableView 의 Outlet 변수
    @IBOutlet var musicTable: UITableView!
    // NavigationBar 의 Right Bar Item
    @IBOutlet var editButton: UIBarButtonItem!
    
    // UITableView 에 들어가게 될 Music 모델 타입의 배열을 생성합니다.
    // Music 모델은 Music.swift 에 선언되어 있습니다.
    var musicList: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMusicData()
        
        // musicTable 의 delegate 와 dataSource 의 위임자를 self 로 지정합니다.
        musicTable.delegate = self
        musicTable.dataSource = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 이 부분은 아래 부분의 didSelectRowAt 부분을 먼저 읽고 다시 와주세요!
        
        /*
            didSelectRowAt 함수에서 해당 셀을 선택하고 음악 상세정보 뷰로 전환되었다가 다시 돌아오면
            그 셀이 선택된 상태로 남아 있는 현상을 해결합니다. (궁금하다면 이 부분을 주석처리하고 실행해보세요!)
            viewDidDisappear 안에 선언되어 뷰가 다시 나타날 때 아래 코드가 실행되고
            현재 선택된 row 의 인덱스를 가져와 그 인덱스에 해당하는 row 를 이용해 deslect 를 해줍니다.
        */
        if let index = musicTable.indexPathForSelectedRow {
            musicTable.deselectRow(at: index, animated: true)
        }
    }

    // Rigt Bar Button - Edit Button
    // 이 IBAction 함수는 네비게이션 바에 있는 Eidt 버튼을 눌렀을 때 실행되는 함수입니다.
    @IBAction func setEditingModeTableView(_ sender: Any) {
        
        // 현재 테이블 뷰가 editing mode 인지 isEditing 메소드를 통해 확인하고 그에 따라서 테이블 뷰의 상태를 결정합니다.
        if musicTable.isEditing {
            editButton.title = "edit"
            musicTable.setEditing(false, animated: true)
        } else {
            editButton.title = "done"
            musicTable.setEditing(true, animated: true)
        }
    }
}

// UITableViewDataSource 를 채택합니다.
extension MusicListVC: UITableViewDataSource {
    
    // UITalbeView 에 얼마나 많은 리스트를 담을 지 설정합니다.
    // 현재는 musicList 배열의 count 갯수 만큼 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return musicList.count
    }
    
    // 각 index 에 해당하는 셀에 데이터를 주입합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = musicTable.dequeueReusableCell(withIdentifier: "MusicCell") as! MusicCell
        
        let music = musicList[indexPath.row]
        
        cell.albumImg.image = music.albumImg
        cell.musicTitle.text = music.musicTitle
        cell.singer.text = music.singer
        
        return cell
    }
}

// UITableViewDelegate 를 채택합니다.
extension MusicListVC: UITableViewDelegate {
    /*
        didSelectRowAt 은 셀을 선택했을때 어떤 동작을 할 지 설정할 수 있습니다.
        여기서는 셀을 선택하면 그에 해당하는 MusicDetailVC 로 화면전환을 합니다.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 아래의 과정들은 1, 2차 세미나의 화면 전환 간 데이터 전달과 같습니다.
        let dvc = storyboard?.instantiateViewController(withIdentifier: "MusicDetailVC") as! MusicDetailVC

        // 맨 아래 extension 에 musicList 배열에 저장하는 부분이 있습니다.
        // 해당하는 인덱스의 Model 을 저장합니다.
        let music = musicList[indexPath.row]
        
        dvc.albumImg = music.albumImg
        dvc.musicTitle = music.musicTitle
        dvc.singer = music.singer
        
        // push 방식으로 화면을 전환합니다.
//        self.present(dvc, animated: true, completion: nil)
        navigationController?.pushViewController(dvc, animated: true)
    } // 여기까지 보셨다면 잠깐 다시 위의 viewDidDisappear로!
    
    // canMoveRowAt은 테이블뷰의 row의 위치를 이동할 수 있는지 없는지 설정합니다.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    /*
        moveRowAt은 테이블 뷰의 row 의 위치가 변화하였을 때, 원하는 작업을 해줄 수 있습니다.
        지금 이 프로젝트에서는 editing mode 에서 row 를 변화 시킴에 따라 이 함수가 실행됩니다.
     */
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        /*
            테이블 뷰 의 row 를 변화시키면 그에 따라 대응되는 모델(데이터)도 변화시켜주어야 합니다.
            sourceIndexPath와 destinationIndexPath를 통해 이동을 시작한 index와 새롭게 설정된 index를 가져올 수 있습니다.
         */
        let movingIndex = musicList[sourceIndexPath.row]
        
        musicList.remove(at: sourceIndexPath.row)
        musicList.insert(movingIndex, at: destinationIndexPath.row)
    /*
        commit editingStyle 은 테이블뷰가 edit 된 스타일에 따라 이벤트를 설정할 수 있습니다.
        여기서는 editing mode 에서 한개의 row 를 delete 하였을 경우에 대한 동작을 설정하였습니다.
     */
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            musicList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
    /*
        임의로 Model 에 직접 데이터를 넣어주는 작업입니다.
        서버를 통해서 받을 때에는 이곳에서 데이터를 받아 모델에 할당합니다.
    */
extension MusicListVC {
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
