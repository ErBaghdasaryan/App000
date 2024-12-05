//
//  StoryCell.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 04.12.24.
//

import UIKit
import AVFoundation

class StoryCell: UICollectionViewCell, IReusableView {

    private var playerLayer: AVPlayerLayer?
    public var player: AVPlayer?

    func setup(image: UIImage) {
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }

    func setupVideo(url: URL) {
        contentView.subviews.forEach { $0.removeFromSuperview() }

        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill

        if let playerLayer = playerLayer {
            contentView.layer.addSublayer(playerLayer)
            playerLayer.frame = contentView.bounds
        }

        player?.play()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
}
