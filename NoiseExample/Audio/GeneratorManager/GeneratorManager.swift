//
//  GeneratorManager.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 27/12/2020.
//

import AVFoundation

class GeneratorManager {
    private let engine: AVAudioEngine
    private let audioUnit: AVAudioUnit
    
    init(
        unit: AVAudioUnit = WhiteNoiseGenerator.loadUnit(),
        engine: AVAudioEngine = .init()
    ) {
        self.engine = engine
        audioUnit = unit
        initAudioSession()
        // set defaults
        engine.mainMixerNode.outputVolume = defaultVolume
        engine.prepare()
        activateSession()
    }
    
    func manageNoise(with state: Bool) {
        switch state {
        case true:
            connectUnit()
            do { try engine.start() }
            catch { print(error) ; return }
            
        case false:
            engine.detach(audioUnit)
            engine.pause()
        }
    }
    
    func manageVolume(with value: Float) {
        engine.mainMixerNode.outputVolume = value
    }
    
    private func connectUnit() {
        engine.attach(audioUnit)
        engine.connect(audioUnit,
                       to: engine.mainMixerNode,
                       format: nil)
    }
    
    deinit {
        self.engine.stop()
        deativateSession()
    }
}
