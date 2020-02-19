//
//  PlayerViewController.swift
//  MyMusicApp
//
//  Created by 최고은 on 2019/12/12.
//  Copyright © 2019 goeun.choi. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    //    - segue 연결하기
    //    - segue 데이터 받기
    //    - 받은데이터 정보 표시하기
    //    - 플레이어 준비하기
    //    - 시간 업데이트 하기
    //    - currentTime
    //    - totalDuration
    //    - 플레이 함수
    //    - 정지 함수
    //    - 시킹
    //    - 플레이 버튼 탭
    //    - 슬라이더 밸류 변경 > Drag
    //    - 드래깅 엔드 > Drag end
    //    - 닫기
        
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationTimeLabel: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    
    var track: Track?
    var avplayer: AVPlayer?
    var timeObserver: Any?
    
    var currentTime: Double {
        return avplayer?.currentItem?.currentTime().seconds ?? 0
    }
    
    var totalDurationTime: Double {
        return avplayer?.currentItem?.duration.seconds ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        prepareToPlay()
        
        timeObserver = avplayer?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 10), queue: DispatchQueue.main) { time in
            // 0.1초마다 시간 업데이트
            self.updateTime(time: time)
        }
    }
    
    func updateUI() {
        guard let currentTrack = track else { return }
        
        thumbnail.image = currentTrack.thumb
        trackTitle.text = currentTrack.title
        artistName.text = currentTrack.artist
        playPauseButton.setImage(#imageLiteral(resourceName: "icPause"), for: .normal)
    }
    
    func prepareToPlay() {
        guard let currentTrack = track else { return }
        
        let asset = currentTrack.asset
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        avplayer = player
        
    }
    
    func updateTime(time: CMTime) {
        // print(time.seconds)
        // currentTime label, totalduration label, slider
        currentTimeLabel.text = secondsToString(sec: currentTime)                 // 3.1234초 >> 00:03
        totalDurationTimeLabel.text = secondsToString(sec: totalDurationTime)     // 39.2045초 >> 00:39
        
        if isSeeking == false  {
            timeSlider.value = Float(currentTime/totalDurationTime)
        }
    }
    
    func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00:00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60             //몫
        let seconds = totalSeconds % 60         //나머지
        return String(format: "%02d:%02d", min, seconds)
    }
    
    func play() {
        avplayer?.play()
    }
    
    func pause() {
        avplayer?.pause()
    }
    
    func seek(to: Double) {
        // to : 0 ~ 1 슬라이드가 0 에서 1 사인데 만약에 0.5면 가운데를 의미 노래가 60초 짜리면 0.5 * 60 이니깐 30초란 의미 --> 30 초는 기준 단위가 1초 일때 인데 우리는 지금 0.1초니깐
        // CMTimeValue(to * totalDurationTime) * CMTimeValue(timeScale) --> 이런식으로 timeScale를 한번 더 곱해야됨
        let timeScale: CMTimeScale = 10
        let targetTime: CMTimeValue = CMTimeValue(to * totalDurationTime) * CMTimeValue(timeScale)
        
        let time = CMTime(value: targetTime, timescale: timeScale)
        avplayer?.seek(to: time)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton){
        let isPlaying = avplayer?.rate == 1
        
        if isPlaying {
            pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "icPlay"), for: .normal)
        } else {
            play()
            playPauseButton.setImage(#imageLiteral(resourceName: "icPause"), for: .normal)
        }
    }
    
    var isSeeking = false
    @IBAction func dragging(_ sender: UISlider) {
        isSeeking = true
    }
    
    @IBAction func endDragging(_ sender: UISlider) {
        isSeeking = false
        seek(to: Double(sender.value))
    }
    
    @IBAction func close() {
        pause()
        avplayer?.replaceCurrentItem(with: nil)
        avplayer = nil
        
        dismiss(animated: true, completion: nil) 
    }
}
