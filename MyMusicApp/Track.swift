//
//  Track.swift
//  MyMusicApp
//
//  Created by 최고은 on 2019/12/11.
//  Copyright © 2019 goeun.choi. All rights reserved.
//

import UIKit
import AVFoundation

class Track {
    var title: String
    var thumb: UIImage
    var artist: String
    
    init(title: String, thumb: UIImage, artist: String) {
        self.title = title
        self.thumb = thumb
        self.artist = artist
    }
    
    var asset: AVAsset {
        let path = Bundle.main.path(forResource: title, ofType: "mov")! // ! --> string optional을 강제로 없앤다는 의미
        let url = URL(fileURLWithPath: path)
        let asset = AVAsset(url: url)
        return asset
    }
}
