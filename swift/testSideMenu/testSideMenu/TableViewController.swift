//
//  TableViewController.swift
//  testSideMenu
//
//  Created by Sunghee Lee on 08/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import SideMenu

class TableViewController: UITableViewController {
    // viewdidload는 한 번만 실행되고
    // viewWillApear는 보일 때마다 특정한 동작을 수행하기 위해서임
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        guard SideMenuManager.default.menuBlurEffectStyle == nil else { return }
        
        let imageView = UIImageView(image: UIImage(named: "cherryBlossom"))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        tableView.backgroundView = imageView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! UITableViewVibrantCell
        
        cell.blurEffectStyle = SideMenuManager.default.menuBlurEffectStyle
        
        return cell
    }
}
