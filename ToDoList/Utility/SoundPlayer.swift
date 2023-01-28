//
//  SoundPlayer.swift
//  ToDoList
//
//  Created by IKAKOOO on 28.01.23.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String = "mp3"){
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("ERORR Playing audio")
        }
    }
}
