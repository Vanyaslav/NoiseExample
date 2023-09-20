//
//  ViewController.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import UIKit

class MainViewController: UIViewController {
    lazy var manageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 80)
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Start", for: .normal)
        button.setTitle("Stop", for: .selected)
        
        button.addTarget(self,
                         action: #selector(manageNoise),
                         for: .primaryActionTriggered)
        return button
    }()
    
    lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = manager.defaultVolume
        slider.tintColor = .secondaryLabel
        
        slider.addTarget(self,
                         action: #selector(manageVolume),
                         for: .valueChanged)
        return slider
    }()
    
    let manager: GeneratorManager
    
    init(manager: GeneratorManager = GeneratorManager()) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
