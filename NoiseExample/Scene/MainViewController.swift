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

// engine operations
extension MainViewController {
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
        engine.detach(whiteNoiseGenerator)
    }
}
// view action
extension MainViewController {
    @objc func manageNoise(_ button: UIButton) {
        let selected = button.isSelected
        button.isSelected = !selected
        button.isSelected
            ? connectUnit()
            : disconnectUnit()
    }
    
    @objc func manageVolume(_ slider: UISlider) {
        generatorMixer.outputVolume = slider.value
    }
}

class MainViewController: UIViewController {
    // subviews
    private lazy var manageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 80)
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Start", for: .normal)
        button.setTitle("Stop", for: .selected)
        
        button.addTarget(self,
                         action: #selector(manageNoise(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = MainViewController.defaultVolume
        slider.tintColor = .secondaryLabel
        
        slider.addTarget(self,
                         action: #selector(manageVolume(_:)),
                         for: .valueChanged)
        return slider
    }()
    // audio
    private lazy var whiteNoiseGenerator: AVAudioUnit = WhiteNoiseGenerator.loadUnit()
    
    private let generatorMixer = AVAudioMixerNode()
    private let engine = AVAudioEngine()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        initAudioSession()
        // need to register the AU
        WhiteNoiseGenerator.registerSubclass
        // connect to the node before start
        connectMixer()
        // set defaults
        generatorMixer.outputVolume = MainViewController.defaultVolume
        
        do { try self.engine.start() }
        catch { print(error) ; return }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGray6
        
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
}

