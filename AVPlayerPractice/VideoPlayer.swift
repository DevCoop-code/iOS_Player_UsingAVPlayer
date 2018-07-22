//
//  VideoPlayer.swift
//  AVPlayerPractice
//
//  Created by HanGyo Jeong on 2018. 7. 22..
//  Copyright © 2018년 HanGyoJeong. All rights reserved.
//
import Foundation
import UIKit
import AVKit
import AVFoundation

class VideoPlayer : UIViewController{
    class VideoPlayerPlaybackView: UIView{
        override class var layerClass: AnyClass{
            return AVPlayerLayer.self
        }
        
        var playerLayer: AVPlayerLayer?{
            return self.layer as? AVPlayerLayer
        }
        
        var player: AVPlayer?{
            get{
                return playerLayer?.player
            }
            set{
                playerLayer?.player = newValue
            }
        }
    }
    
    @IBOutlet weak var playbackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
