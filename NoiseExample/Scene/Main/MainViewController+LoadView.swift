//
//  MainViewController+LoadView.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 27/12/2020.
//

import UIKit

extension MainViewController {
    override func loadView() {
        super.loadView()
        
        [manageButton, volumeSlider]
            .forEach(view.addSubview)
        
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
