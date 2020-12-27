//
//  GeneratorManager+Defaults.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 27/12/2020.
//

import AVFoundation

// default settings
extension GeneratorManager {
    var defaultVolume: Float { 0.15 }
}

extension GeneratorManager: AudioSessionProtocol {}
