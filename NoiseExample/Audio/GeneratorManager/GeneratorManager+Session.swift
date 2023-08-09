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
        } catch { process(with: error) }
    }
    
    func deativateSession() {
        do { try AVAudioSession.sharedInstance().setActive(false) }
        catch { process(with: error) }
    }
    
    func activateSession() {
        do { try AVAudioSession.sharedInstance().setActive(true) }
        catch { process(with: error) }
    }
    
    private
    func process(with error: Error) {
        NSLog("Failed to manage session on AVAudioSession error: %@", error.localizedDescription)
    }
}
