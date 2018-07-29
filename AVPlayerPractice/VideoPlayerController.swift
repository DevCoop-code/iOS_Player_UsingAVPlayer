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

class VideoPlayerController : UIViewController{
    
    @IBOutlet weak var playbackView: VideoPlayerPlaybackView!
    
    fileprivate var player: AVPlayer!
    
    private struct ObservationContexts {
        static var Status = 0
        static var Duration = 1
        static var BufferEmpty = 2
        static var PlaybackLikelyToKeepUp = 3
        static var PresentationSize = 4
        static var CurrentItem = 5
        static var Rate = 6
        static var ExternalPlayback = 7
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playMainMovie()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        destroyPlayer()
    }
    
    private func destroyPlayer(){
        destroyAVPlayer()
    }
    fileprivate func destroyAVPlayer(){
        player = nil
    }
    
    private func playMainMovie(){
        let videoUrl: URL = URL.init(string:"https://mnmedias.api.telequebec.tv/m3u8/29880.m3u8")!
        playAsset(withURL: videoUrl)
    }
    private func playAsset(withURL url: URL){
        let sendToPlayer = {
            [weak self] (urlAsset: AVURLAsset) -> Void in
            let requestedKeys = [Constraints.Keys.Tracks, Constraints.Keys.Playable]
            /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
            urlAsset.loadValuesAsynchronously(forKeys: requestedKeys){
                [weak self] in
                /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                DispatchQueue.main.async {
                    self?.prepareToPlay(asset: urlAsset, withKeys: requestedKeys)
                }
            }
        }
        sendToPlayer(AVURLAsset(url: url))
    }
    private func prepareToPlay(asset: AVURLAsset, withKeys keys: [String]? = nil){
        /* Make sure that the value of each key has loaded successfully. */
        if let keys = keys{
            for key in keys{
                let error: NSErrorPointer = nil
                let status = asset.statusOfValue(forKey: key, error: error)
                if status == .failed{
                    print("Error in player status")
                    return
                }
            }
        }
        
        // Create a new instance of AVPlayerItem from the now successfully loaded AVAsset.
        let playerItem = AVPlayerItem(asset: asset)
        
        /* Create new player, if we don't already have one. */
        if player == nil{
            player = AVPlayer(playerItem: playerItem)
            
            /* Observe the AVPlayer "currentItem" property to find out when any
             AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did occur.*/
            player!.addObserver(self, forKeyPath: Constraints.Keys.CurrentItem, options: [.initial, .new], context: &ObservationContexts.CurrentItem)
            
            /* Observe the AVPlayer "rate" property to update the scrubber control. */
            player!.addObserver(self, forKeyPath: Constraints.Keys.Rate, options: [.initial, .new], context: &ObservationContexts.Rate)
            
            /* Observer the AVPlayer "externalPlaybackActive" property to update the UI when AirPlay connects or disconnects. */
            player!.addObserver(self, forKeyPath: Constraints.Keys.ExternalPlaybackActive, options: [.initial, .new], context: &ObservationContexts.ExternalPlayback)
            
            player!.addObserver(self, forKeyPath: Constraints.Keys.CurrentItemStatus, options: [.initial, .new], context: &ObservationContexts.Status)
            player!.addObserver(self, forKeyPath: Constraints.Keys.CurrentItemDuration, options: [.initial, .new], context: &ObservationContexts.Duration)
            player!.addObserver(self, forKeyPath: Constraints.Keys.CurrentItemPlaybackBufferEmpty, options: .new, context: &ObservationContexts.BufferEmpty)
            player!.addObserver(self, forKeyPath: Constraints.Keys.CurrentItemPlaybackLikelyToKeepUp, options: .new, context: &ObservationContexts.PlaybackLikelyToKeepUp)
            player!.addObserver(self, forKeyPath: Constraints.Keys.CurrentItemPresentationSize, options: .new, context: &ObservationContexts.PresentationSize)
        }
        
        /* Make our new AVPlayerItem the AVPlayer's current item. */
        if player!.currentItem != playerItem{
            /* Replace the player item with a new player item. The item replacement occurs
             asynchronously; observe the currentItem property to find out when the
             replacement will/did occur
             
             If needed, configure player item here (example: adding outputs, setting text style rules,
             selecting media options) before associating it with a player
             */
            player!.replaceCurrentItem(with: playerItem)
        }
    }
    
    private func playVideo(){
        player.play()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        /* AVPlayer "currentItem" property observer.
         Called when the AVPlayer replaceCurrentItemWithPlayerItem:
         replacement will/did occur. */
        if context == &ObservationContexts.CurrentItem{
            /* Replacement of player currentItem has occurred */
            if(change?[NSKeyValueChangeKey.newKey] as? AVPlayerItem) != nil{
                /* Set the AVPlayer for which the player layer displays visual output. */
                playbackView.player = player
                playVideo()
            }
        }
    }
}
