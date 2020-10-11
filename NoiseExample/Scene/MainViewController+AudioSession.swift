//
//  MainViewController+AudioSession.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 11/10/2020.
//

import AVFoundation

extension MainViewController {
    func initAudioSession() {
        let session = AVAudioSession.sharedInstance()
        // setup session
        do { try session.setCategory(.playback,
                                     mode: AVAudioSession.Mode.default,
                                     options: .interruptSpokenAudioAndMixWithOthers)
            guard let format = KernelAudioUnit.audioFormat else { return }
            
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
