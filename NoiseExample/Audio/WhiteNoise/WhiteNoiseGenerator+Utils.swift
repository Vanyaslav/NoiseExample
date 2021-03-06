//
//  WhiteNoiseGenerator+Utils.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import AVFoundation

extension WhiteNoiseGenerator {
    static let audioComponentDescription = AudioComponentDescription(
        componentType: kAudioUnitType_Generator,
        componentSubType: "wngn".hfsTypeCode,
        componentManufacturer: "Test".hfsTypeCode,
        componentFlags: 0,
        componentFlagsMask: 0
    )
    
    static let registerSubclass: Void = {
        AUAudioUnit.registerSubclass(
            WhiteNoiseGenerator.self,
            as: audioComponentDescription,
            name: "WhiteNoiseGenerator",
            version: 001
        )
    }()
}
