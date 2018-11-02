//
//  Helper.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-11-02.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import Foundation
import AVFoundation

class Helper {
        //
    static func bluetoothOrHeadphonesConnected() -> Bool {
        
        let outputs = AVAudioSession.sharedInstance().currentRoute.outputs
        
        for output in outputs{
            
            if output.portType == AVAudioSession.Port.bluetoothA2DP ||
                output.portType == AVAudioSession.Port.bluetoothHFP ||
                output.portType == AVAudioSession.Port.bluetoothLE ||
                output.portType == AVAudioSession.Port.headphones {
                return true
            }
        }
        return false
    }
}
