//
//  ViewController.swift
//  AVPlayerPractice
//
//  Created by HanGyo Jeong on 2018. 7. 22..
//  Copyright © 2018년 HanGyoJeong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playerContainerView: UIView!
    
    private var videoController : VideoPlayer?{
        for viewController in self.childViewControllers{
            if let videoController = viewController as? VideoPlayer{
                return videoController
            }
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Any
    }
}

