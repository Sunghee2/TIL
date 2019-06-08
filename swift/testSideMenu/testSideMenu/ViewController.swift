//
//  ViewController.swift
//  testSideMenu
//
//  Created by Sunghee Lee on 08/06/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import SideMenu

class ViewController: UIViewController {

    @IBOutlet var sampleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupSideMenu()
    }
    
    @IBAction func actionBtn(_ sender: Any) {
        affine()
    }
    
    @IBAction func hideBtn(_ sender: Any) {
        show()
    }
    
    func affine() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            // .identity로 설정하면 원상태로 돌아감.
//            self.sampleView.transform = .identity
            self.sampleView.transform = CGAffineTransform(scaleX: 1, y: 0)
        })
    }
    
    func show() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            // .identity로 설정하면 원상태로 돌아감.
            self.sampleView.transform = .identity
        })
    }
    
    func setupSideMenu() {
        // 만약 아래 gesture 를 사용하고 싶다면 아래 코드를 작성해야합니다.
         SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // 네비게이션 바에 pan gesture 를 등록합니다.
        // pen gesture는 스와이프 말고 드래그하는 느낌.
         SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        
        // View 의 가장자리에 pan gesture 를 등록합니다.
        // 원래는 뒤로가기인데 이것을 하면 옆에 사이드메뉴가 나오게 됨.
         SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        
        // Side Menu 의 애니메이션을 지정합니다.
        // 옵션은 .menuSlideIn, .viewSlideOut, viewSlideInOut, .menuDissolveIn 이 있습니다.
        SideMenuManager.default.menuPresentMode = .viewSlideOut
        
        // Side Menu 의 이펙트를 지정합니다. 하나하나 바꿔보세요.
        // 옵션은 .extraLight, .light, .dark, .regular, .prominent, nil 이 있습니다.
        SideMenuManager.default.menuBlurEffectStyle = nil
        
        // Side Menu 가 보일 때 기존 ViewController 의 투명도
        // 0.0 ~ 1.0
        SideMenuManager.default.menuAnimationFadeStrength = 0
        // Side Menu 의 투명도
        // 0.0 ~ 1.0
        SideMenuManager.default.menuShadowOpacity = 0.3
        // Side Menu 가 보일 때 기존 ViewController 의 크기
        // 0.001 ~ 2.0
        SideMenuManager.default.menuAnimationTransformScaleFactor = 1
        // Side Menu 의 Width
        // 0 ~ self.view.frame.width
        SideMenuManager.default.menuWidth = 200
        // Side Menu 의 Status Bar 에 대한 침범 여부를 결정합니다.
        // true - 침범하지 않음, false - 침범함
        SideMenuManager.default.menuFadeStatusBar = false
        
        // menuFadeStatusBar 가 true 일 때
        // Side Menu 가 보일 때 Status bar 의 배경 이미지를 지정합니다.
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "cherryBlossom")!)
    }
}

// delegate 로 시점을 캐치할 수도 있습니다.
extension ViewController: UISideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}

