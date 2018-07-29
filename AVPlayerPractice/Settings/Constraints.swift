//
//  Constraints.swift
//  AVPlayerPractice
//
//  Created by HanGyo Jeong on 2018. 7. 29..
//  Copyright © 2018년 HanGyoJeong. All rights reserved.
//

import Foundation

struct Constraints{
    struct Keys {
        static let Rate = "rate"
        static let Tracks = "tracks"
        static let Playable = "playable"
        static let ExternalPlaybackActive = "externalPlaybackActive"
        static let CurrentItem = "currentItem"
        static let CurrentItemStatus = "currentItem.status"
        static let CurrentItemDuration = "currentItem.duration"
        static let CurrentItemPlaybackBufferEmpty = "currentItem.playbackBufferEmpty"
        static let CurrentItemPlaybackLikelyToKeepUp = "currentItem.playbackLikelyToKeepUp"
        static let CurrentItemPresentationSize = "currentItem.presentationSize"
        static let AreWirelessRoutesAvailable = "areWirelessRoutesAvailable"
    }
}
