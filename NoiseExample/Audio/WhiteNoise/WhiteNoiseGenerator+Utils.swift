//
//  WhiteNoiseGenerator+Utils.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import AVFoundation

extension WhiteNoiseGenerator {
    static let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0,
                                           channels: 2)
}

extension WhiteNoiseGenerator {
    static let audioComponentDescription = AudioComponentDescription(
        componentType: kAudioUnitType_Generator,
        componentSubType: hfsTypeCode("wngn"),
        componentManufacturer: hfsTypeCode("Test"),
        componentFlags: 0,
        componentFlagsMask: 0
    );
    
    static let registerSubclass: Void = {
        AUAudioUnit.registerSubclass(
            WhiteNoiseGenerator.self,
            as: WhiteNoiseGenerator.audioComponentDescription,
            name: "WhiteNoiseGenerator",
            version: 001
        )
    }()
}
