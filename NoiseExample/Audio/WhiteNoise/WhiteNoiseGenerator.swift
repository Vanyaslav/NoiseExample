//
//  WhiteNoiseGenerator+Construct.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import AVFoundation

extension KernelAudioUnit: AudioSessionProtocol {}

class WhiteNoiseGenerator: KernelAudioUnit {
    static func loadUnit() -> AVAudioUnit {
        registerSubclass
        var audioUnit: AVAudioUnit?
        AVAudioUnit.instantiate(with: audioComponentDescription,
                                options: AudioComponentInstantiationOptions(rawValue: 0))
        { (audioUnitNode: AVAudioUnit?, err: Error?) -> Void in
            guard let audioUnitNode = audioUnitNode else {
                if let err = err { print(err) }
                return
            }
            
            guard let generatorUnit = audioUnitNode.auAudioUnit as? WhiteNoiseGenerator else {
                return
            }
    
            generatorUnit.createRendering()
            audioUnit = audioUnitNode
        }
        return audioUnit!
    }
}
