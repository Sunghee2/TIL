//
//  ViewController.swift
//  Carousel
//
//  Created by Sunghee Lee on 18/05/2019.
//  Copyright © 2019 Sunghee Lee. All rights reserved.
//

import UIKit
import ZKCarousel

class ViewController: UIViewController {

    @IBOutlet var carousel: ZKCarousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    private func setupCarousel() {
        
        // Create as many slides as you'd like to show in the carousel
        let slide = ZKCarouselSlide(image: UIImage(named: <#T##String#>), title: "Hello There", description: "Welcome to the ZKCarousel demo! Swipe left to view more slides!")
        let slide1 = ZKCarouselSlide(image: UIImage, title: "A Demo Slide", description: "lorem ipsum devornum cora fusoa foen sdie ha odab ebakldf shjbesd ljkhf")
        let slide2 = ZKCarouselSlide(image: #imageLiteral(resourceName: "demo2"), title: "Another Demo Slide", description: "lorem ipsum devornum cora fusoa foen ebakldf shjbesd ljkhf")
        let slide3 = ZKCarouselSlide(image: #imageLiteral(resourceName: "demo2"), title: "Hello There", description: "Welcome to the ZKCarousel demo! Swipe left to view more slides!")
        let slide4 = ZKCarouselSlide(image: #imageLiteral(resourceName: "demo"), title: "A Demo Slide", description: "lorem ipsum devornum cora fusoa foen sdie ha odab ebakldf shjbesd ljkhf")
        let slide5 = ZKCarouselSlide(image: #imageLiteral(resourceName: "demo2"), title: "Another Demo Slide", description: "lorem ipsum devornum cora fusoa foen ebakldf shjbesd ljkhf")
        
        // Add the slides to the carousel
        self.carousel.slides = [slide, slide1, slide2, slide3, slide4, slide5]
        
        
        // You can optionally use the 'interval' property to set the timing for automatic slide changes. The default is 1 second.
        self.carousel.interval = 1.5
        
        // Optional - automatic switching between slides.
        self.carousel.start()
    }
}

