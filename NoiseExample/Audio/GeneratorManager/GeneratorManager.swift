//
//  GeneratorManager.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 27/12/2020.
//

import AVFoundation

class GeneratorManager {
    private
    let engine: AVAudioEngine
    private
    let unit: AVAudioUnit
    
    init(with engine: AVAudioEngine = AVAudioEngine(),
         audioUnit: AVAudioUnit = WhiteNoiseGenerator.loadUnit()) {
        self.unit = audioUnit
        self.engine = engine
        // set defaults
        engine.mainMixerNode.outputVolume = defaultVolume
        
        do { try self.engine.start() }
        catch { print(error) ; return }
        
        initAudioSession()
    }
    
    func manageNoise(with state: Bool) {
        state ? connectUnit() : engine.detach(unit)
    }
    
    func manageVolume(with value: Float) {
        engine.mainMixerNode.outputVolume = value
    }
    
    private
    func connectUnit() {
        engine.attach(unit)
        engine.connect(unit,
                       to: engine.mainMixerNode,
                       format: nil)
    }
}
