//
//  MongolAudioPlayer.swift
//  GargantaResearch
//
//  Created by Yago Teixeira on 24/05/16.
//  Copyright © 2016 Gustavo Henrique. All rights reserved.
//

import AVFoundation

class MongolAudioPlayer: AVAudioPlayer {
    override init() {
        do{
            let path = NSBundle.mainBundle().URLForResource("ezenggileer", withExtension: "mp3")
            try super.init(contentsOfURL: path!)
        }catch{
            print(error)
        }
    }
}
