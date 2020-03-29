//
//  CommentVC.swift
//  SOPT_24th_iOS_Seminar_4th
//
//  Created by Sunghee Lee on 25/05/2019.
//  Copyright © 2019 wookeon. All rights reserved.
//

import UIKit

//class CommentVC: UIViewController {
//
//    var commentList = [CommentList]()
//    var epIdx: Int?
//
//    @IBOutlet var commentTV: UITableView!
//    @IBOutlet var writeBtn: UIButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        registerTVC()
////        CommentVC.delegate = self
//        commentTV.dataSource = self
//    }
//    
//    func registerTVC() {
//        let nibName = UINib(nibName: "CommentTVC", bundle: nil)
//        commentTV.register(nibName, forCellReuseIdentifier: "CommentTVC")
//    }
//    
//    func setNavigationBar() {
//        self.setBackBtn(color: UIColor.brownishGrey)
//        self.setCommentBtn(color: UIColor.yellow)
//        self.setNavigationBarShadow()
//    }
//    
//    @IBAction func writeBtnAction(_ sender: Any) {
//        let dvc = storyboard?.instantiateViewController(withIdentifier: "CommentNewVC") as! CommentNewVC
//
//        let comment = commentList[IndexPath.row]
//        dvc.epIdx = comment.idx
//        navigationController?.pushViewController(dvc, animated: true)
//    }
//    
//    
//    
//}
//
//extension CommentVC: UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return commentList.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = commentTV.dequeueReusableCell(withIdentifier: "CommentTVC") as! CommentTVC
//        
//        let comment = commentList[indexPath.row]
//        
//        cell.thumbnailImg.imageFromUrl(gsno(comment.thumbnail), defaultImgPath: "defaultImg")
//        cell.nameLabel.text = comment.name
//        cell.commentLabel.text = comment.content
//        cell.dateLabel.text = comment.date
//        
//        
//        return cell
//    }
//}

// UITableViewDelegate 를 채택합니다. 클릭할때라 필요없을듯
//extension CommentVC: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let dvc = storyboard?.instantiateViewController(withIdentifier: "EpisodeDetailVC") as! EpisodeDetailVC
//
//        let episode = episodeList[indexPath.row]
//
//        dvc.epIdx = episode.idx
//
//        navigationController?.pushViewController(dvc, animated: true)
//    }
//}
