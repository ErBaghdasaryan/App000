//
//  PublicationView.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import UIKit
import AVFoundation

class PublicationView: UIView, IReusableView {

    private var playerLayer: AVPlayerLayer?
    public var player: AVPlayer?

    func setup(image: UIImage) {
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        imageView.frame = self.bounds
    }

    func setupVideo(url: URL) {
        self.subviews.forEach { $0.removeFromSuperview() }

        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill

        if let playerLayer = playerLayer {
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.bounds
        }

        player?.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
}
