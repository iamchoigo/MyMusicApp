//
//  TrackListViewController.swift
//  MyMusicAppUITests
//
//  Created by 최고은 on 2019/12/11.
//  Copyright © 2019 goeun.choi. All rights reserved.
//

import UIKit

class TrackListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //    - 트랙 모델 만들기
    //    - 트랙 리스트 만들기
    //    - TableViewDelegate, TableViewDatasource
    //    - 커스텀 테이블 뷰셀
    //    - 뷰 구성하기
    
    var musicTrackList: [Track] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlayer" {
            if let playerVC = segue.destination as? PlayerViewController, let index = sender as? Int {
                playerVC.track = musicTrackList[index]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrackList()
    }
    
    func loadTrackList() {
        musicTrackList = [
            Track(title: "Swish", thumb: #imageLiteral(resourceName: "Swish"), artist: "Tyga"), // 이미지 넣는 방법 #imageLiteral 이용해서 붙여넣음
            Track(title: "Dip", thumb: #imageLiteral(resourceName: "Dip"), artist: "Tyga"),
            Track(title: "The Harlem Barber Swing", thumb: #imageLiteral(resourceName: "The Harlem Barber Swing"), artist: "Jazzinuf"),
            Track(title: "Believer", thumb: #imageLiteral(resourceName: "Believer"), artist: "Imagine Dragon"),
            Track(title: "Blue Birds", thumb: #imageLiteral(resourceName: "Blue Birds"), artist: "Eevee"),
            Track(title: "Best Mistake", thumb: #imageLiteral(resourceName: "Best Mistake"), artist: "Ariana Grande"),
            Track(title: "thank u, next", thumb: #imageLiteral(resourceName: "thank u, next"), artist: "Ariana Grande"),
            Track(title: "7 rings", thumb: #imageLiteral(resourceName: "7 rings"), artist: "Ariana Grande")
        ]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicTrackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TrackCell else {
            return UITableViewCell()
        }
        
        let track = musicTrackList[indexPath.row]
        cell.thumbnail.image = track.thumb
        cell.title.text = track.title
        cell.artist.text = track.artist
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("--> \(indexPath.row)")
        performSegue(withIdentifier: "ShowPlayer", sender: indexPath.row)
    }

}

class TrackCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
}
