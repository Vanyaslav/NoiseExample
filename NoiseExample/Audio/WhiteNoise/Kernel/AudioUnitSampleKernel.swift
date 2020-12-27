//
//  AudioKernel.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import AVFoundation

public typealias KernelRenderBlock = (_ buffer: AVAudioPCMBuffer) -> Void

class AudioUnitSampleKernel {
    @Atomic var buffer: AVAudioPCMBuffer?
    @Atomic var renderBlock: KernelRenderBlock?
}
