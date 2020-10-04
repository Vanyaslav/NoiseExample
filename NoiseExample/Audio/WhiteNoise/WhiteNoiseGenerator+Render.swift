//
//  WhiteNoiseGenerator+Render.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import AVFoundation


extension WhiteNoiseGenerator {
    // MARK: - Definition
    // https://developer.apple.com/documentation/avfoundation/audio_playback_recording_and_processing/avaudioengine/building_a_signal_generator
    static let whiteNoise = { () -> Float in
        return ((Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX)) * 2 - 1)
    }
}

extension WhiteNoiseGenerator {
    func createRendering() {
        kernelRenderBlock = { buffer in
            let value = WhiteNoiseGenerator.whiteNoise
            
            func proces(_ out_data: UnsafeMutablePointer<Float32>) {
                for i in 0 ..< buffer.frameLength {
                    out_data[Int(i)] = Float32(value())
                }
            }
            
            for ch in 0 ..< buffer.format.channelCount {
                if let channelData = buffer.floatChannelData {
                    proces(channelData[Int(ch)])
                }
            }
        }
    }
}
