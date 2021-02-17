//
//  GeneratorManager.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 27/12/2020.
//

import AVFoundation

class GeneratorManager {
    private
    let engine = AVAudioEngine()
    private
    let audioUnit: AVAudioUnit
    
    init(with unit: AVAudioUnit = WhiteNoiseGenerator.loadUnit()) {
        audioUnit = unit
        initAudioSession()
        // set defaults
        engine.mainMixerNode.outputVolume = defaultVolume
        engine.prepare()
    }
    
    func manageNoise(with state: Bool) {
        if state {
            activateSession()
            connectUnit()
            do { try engine.start() }
            catch { print(error) ; return }
        } else {
            engine.detach(audioUnit)
            engine.pause()
            deativateSession()
        }
    }
    
    func manageVolume(with value: Float) {
        engine.mainMixerNode.outputVolume = value
    }
    
    private
    func connectUnit() {
        engine.attach(audioUnit)
        engine.connect(audioUnit,
                       to: engine.mainMixerNode,
                       format: nil)
    }
    
    deinit {
        self.engine.stop()
    }
}
