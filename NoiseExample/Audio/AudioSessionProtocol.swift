//
//  AudioSessionProtocol.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 27/12/2020.
//

import AVFoundation

protocol AudioSessionProtocol {
    func audioFormat() -> AVAudioFormat?
}

extension AudioSessionProtocol {
    func audioFormat() -> AVAudioFormat? {
        AVAudioFormat(standardFormatWithSampleRate: 44100.0,
                      channels: 2)
    }
}
