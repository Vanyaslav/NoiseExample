//
//  WhiteNoiseGenerator+Defaults.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import Foundation

extension WhiteNoiseGenerator {
    // Definition
    // https://developer.apple.com/documentation/avfoundation/audio_playback_recording_and_processing/avaudioengine/building_a_signal_generator
    static let signal = { () -> Float in
        return ((Float32(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX)) * 2 - 1)
    }
}
