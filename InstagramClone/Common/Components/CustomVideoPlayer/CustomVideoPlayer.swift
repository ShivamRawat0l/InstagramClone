//
//  CustomVideoPlayer.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 02/11/23.
//

import AVKit
import SwiftUI

struct CustomVideoPlayer: View {
    @StateObject var videoPlayerController: CustomVideoPlayerViewController

    init(url: URL) {
        self._videoPlayerController = StateObject(wrappedValue: CustomVideoPlayerViewController(url: url))
    }

    var body: some View {
        ZStack {
            VideoPlayer(player: videoPlayerController.avPlayer)
                .frame(maxWidth: .infinity)
                .scaledToFit()
                .disabled(true)
            if videoPlayerController.playerStatus == .Loading {
                CustomShimmer(height: 400.0)
            }
            Group {
                Spacer()
                Button {
                    switch videoPlayerController.playerStatus {
                    case .Loading:
                        // TODO: Add some funcitonliaty
                        print("Loading")
                    case .Ended:
                        videoPlayerController.avPlayer.seek(to: .zero)
                        videoPlayerController.avPlayer.play()
                        videoPlayerController.playerStatus = .Playing
                    case .Playing:
                        videoPlayerController.avPlayer.pause()
                        videoPlayerController.playerStatus = .Paused
                    case .Paused:
                        videoPlayerController.avPlayer.play()
                        videoPlayerController.playerStatus = .Playing
                    }
                } label: {
                    switch videoPlayerController.playerStatus {
                    case .Loading:
                        EmptyView()
                    case .Ended:
                        Image(systemName: "arrow.circlepath")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    case .Playing:
                        Image(systemName: "pause.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    case .Paused:
                        Image(systemName: "play.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
        }
    }
}
