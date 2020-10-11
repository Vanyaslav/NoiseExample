//
//  ViewController.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import UIKit
import AVFoundation

extension MainViewController {
    static let defaultVolume: Float = 0.3
}

extension MainViewController {
    private func initAudioSession() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playback,
                                    mode: AVAudioSession.Mode.default,
                                    options: .interruptSpokenAudioAndMixWithOthers)
            guard let format = KernelAudioUnit.audioFormat else {
                return
            }
            try session.setPreferredSampleRate(format.sampleRate)
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
// engine operations
extension MainViewController {
    private func connectMixer() {
        engine.attach(generatorMixer)
        engine.connect(generatorMixer,
                       to: engine.mainMixerNode,
                       format: nil)
        generatorMixer.outputVolume = MainViewController.defaultVolume
    }
    
    private func connectUnit() {
        engine.attach(whiteNoiseGenerator)
        engine.connect(whiteNoiseGenerator,
                       to: generatorMixer,
                       format: nil)
    }
    
    private func disconnectUnit() {
        engine.detach(whiteNoiseGenerator)
    }
}

class MainViewController: UIViewController {
    private lazy var manageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 40)
        button.setTitleColor(.label, for: .normal)
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
    
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self,
                         action: #selector(manageVolume(_:)),
                         for: .valueChanged)
        slider.value = MainViewController.defaultVolume
        return slider
    }()
    
    @objc func manageVolume(_ slider: UISlider) {
        generatorMixer.outputVolume = slider.value
    }
    
    private lazy var whiteNoiseGenerator = WhiteNoiseGenerator.loadUnit()
    private let generatorMixer = AVAudioMixerNode()
    private let engine = AVAudioEngine()
    
    override func loadView() {
        super.loadView()
        view.addSubview(manageButton)
        view.addSubview(volumeSlider)
        
        NSLayoutConstraint.activate([
            manageButton.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),
            manageButton.centerXAnchor
                .constraint(equalTo: view.centerXAnchor),
            
            volumeSlider.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                            constant: 10),
            volumeSlider.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                            constant: -10),
            volumeSlider.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                            constant: -30)
            
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        initAudioSession()
        // need to register the AU
        WhiteNoiseGenerator.registerSubclass
        // the engine has to be connected before start
        connectMixer()
        
        do { try self.engine.start() }
        catch { print(error) ; return }
    }
}

