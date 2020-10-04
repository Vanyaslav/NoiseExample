//
//  ViewController.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import UIKit
import AVFoundation

extension MainViewController {
    private func initAudioSession() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playback,
                                    mode: AVAudioSession.Mode.default,
                                    options: .interruptSpokenAudioAndMixWithOthers)
            try session.setPreferredSampleRate(WhiteNoiseGenerator.audioFormat!.sampleRate)
        } catch let error {
            NSLog("Failed to set category on AVAudioSession error: %@", error.localizedDescription)
        }
        //
        do {
            try session.setActive(true)
        } catch let error {
            NSLog("Failed to set active session on AVAudioSession error: %@", error.localizedDescription)
        }
    }
}

class MainViewController: UIViewController {
    private lazy var manageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 40)
        button.addTarget(self,
                         action: #selector(manageNoise(_:)),
                         for: .touchUpInside)
        button.setTitle("Start", for: .normal)
        button.setTitle("Stop", for: .selected)
        return button
    }()
    
    @objc func manageNoise(_ button: UIButton) {
        let selected = button.isSelected
        button.isSelected = !selected
        selected
            ? disconnectUnit()
            : connectUnit()
    }
    
    private lazy var whiteNoiseGenerator = WhiteNoiseGenerator.loadUnit()
    private let generatorMixer = AVAudioMixerNode()
    private let engine = AVAudioEngine()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(manageButton)
        
        NSLayoutConstraint.activate([
            manageButton.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            manageButton.centerXAnchor
                .constraint(equalTo: view.centerXAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initAudioSession()
        // need to redister the AU
        WhiteNoiseGenerator.registerSubclass
        // the engine needs to be connected before start
        connectMixer()
        engine.prepare()
        
        do { try self.engine.start() }
        catch { print(error) ; return }
    }
    
    private func connectMixer() {
        engine.attach(generatorMixer)
        engine.connect(generatorMixer,
                       to: engine.mainMixerNode,
                       format: nil)
    }
    
    private func connectUnit() {
        engine.attach(whiteNoiseGenerator)
        engine.connect(whiteNoiseGenerator,
                       to: generatorMixer,
                       format: nil)
    }
    
    private func disconnectUnit() {
        // detach disconnect safely by default
        engine.detach(whiteNoiseGenerator)
    }
}

