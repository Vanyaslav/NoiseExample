//
//  MainViewController+Action.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 27/12/2020.
//

import UIKit

// view action
extension MainViewController {
    @objc
    func manageNoise(_ button: UIButton) {
        let selected = button.isSelected
        button.isSelected = !selected
        manager.manageNoise(with: !selected)
    }
    
    @objc
    func manageVolume(_ slider: UISlider) {
        manager.manageVolume(with: slider.value)
    }
}
