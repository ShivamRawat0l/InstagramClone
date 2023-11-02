//
//  CustomVideoPlayerController.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 02/11/23.
//

import Foundation
import AVKit

class CustomVideoPlayerViewController: ObservableObject {
    var avPlayer: AVPlayer
    var avPlayerItem: AVPlayerItem
    
    @Published var playerStatus: VideoPlayerStatus = .Paused

    init(url: URL) {
        self.avPlayerItem = AVPlayerItem(url: url)
        self.avPlayer = AVPlayer(playerItem: avPlayerItem)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object:  self.avPlayer.currentItem,
                                               queue: nil) { _ in
            self.playerStatus = .Ended
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: self.avPlayer.currentItem)
    }
}
