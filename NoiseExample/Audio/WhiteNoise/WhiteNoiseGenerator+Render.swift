//
//  WhiteNoiseGenerator+Render.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import AVFoundation

extension WhiteNoiseGenerator {
    func createRendering() {
        kernelRenderBlock = { buffer in
            func proces(_ out_data: UnsafeMutablePointer<Float32>) {
                for i in 0 ..< buffer.frameLength {
                    out_data[Int(i)] = Self.signal()
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
