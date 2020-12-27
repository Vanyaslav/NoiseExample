//
//  GeneratorManager+Session.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 27/12/2020.
//

import AVFoundation

extension GeneratorManager {
    func initAudioSession() {
        let session = AVAudioSession.sharedInstance()
        // setup session
        do { try session.setCategory(.playback,
                                     mode: AVAudioSession.Mode.default,
                                     options: .interruptSpokenAudioAndMixWithOthers)
            guard let format = audioFormat() else { return }
            
            try session.setPreferredSampleRate(format.sampleRate)
        } catch let error {
            NSLog("Failed to set category on AVAudioSession error: %@", error.localizedDescription)
        }
        // activate session
        do { try session.setActive(true) }
        catch let error {
            NSLog("Failed to set active session on AVAudioSession error: %@", error.localizedDescription)
        }
    }
}
