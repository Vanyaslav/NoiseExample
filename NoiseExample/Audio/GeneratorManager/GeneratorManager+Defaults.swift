//
//  GeneratorManager+Defaults.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 27/12/2020.
//

import AVFoundation

// default settings
extension GeneratorManager {
    var defaultVolume: Float { 0.1 }
}

extension GeneratorManager: AudioSessionProtocol {}
