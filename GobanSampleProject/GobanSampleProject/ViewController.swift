//
//  ViewController.swift
//  GobanSampleProject
//
//  Created by Bobo on 3/19/16.
//  Copyright © 2016 Boris Emorine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var gobanView = makeGoBanView()
    private lazy var gobanManager = makeGoBanManager()
    private lazy var buttonsContainer = makeButtonsContainer()
    private lazy var clearButton = makeClearButton()
    private lazy var previousButton = makePreviousButton()
    private lazy var nextButton = makeNextButton()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let path = Bundle.main.url(forResource: "test", withExtension:"sgf")
        gobanManager.loadSGFFileAtURL(path!)
        gobanManager.shouldMarkupLastStone = true
        
        view.addSubview(gobanView)
        view.addSubview(buttonsContainer)
        NSLayoutConstraint.activate(
            [
                gobanView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                gobanView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                gobanView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                gobanView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                buttonsContainer.topAnchor.constraint(equalTo: gobanView.bottomAnchor, constant: 10),
                buttonsContainer.leadingAnchor.constraint(equalTo: gobanView.leadingAnchor),
                buttonsContainer.trailingAnchor.constraint(equalTo: gobanView.trailingAnchor)
            ]
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        while gobanManager.nextNode != nil {
//            gobanManager.handleNextNode(animated: true)
//        }
    }
    
    @objc private func clearButtonPress(_ sender: UIButton) {
        gobanManager.removeAllStonesAnimated(true)
    }
    
    @objc private func previousButtonPress(_ sender: UIButton) {
        if let currentStone = gobanManager.lastStone {
            gobanManager.removeStone(currentStone, removeFromHistory: false, animated: false)
        }
    }
    
    @objc private func nextButtonPress(_ sender: UIButton) {
        gobanManager.handleNextNode(animated: true)
    }
}

extension ViewController {
    private func makeGoBanView() -> GobanView {
        let view = GobanView(
            size: GobanSize(width: 13, height: 13),
            frame: .zero
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func makeGoBanManager() -> GobanManager {
        let manager = GobanManager(gobanView: gobanView)
        gobanView.gobanTouchDelegate = manager
        return manager
    }
    
    private func makeButtonsContainer() -> UIView {
        let view = UIStackView(arrangedSubviews: [clearButton, previousButton, nextButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 5
        return view
    }
    
    private func makeClearButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(clearButtonPress(_:)), for: .touchUpInside)
        return button
    }
    
    private func makePreviousButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Previous", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(previousButtonPress(_:)), for: .touchUpInside)
        return button
    }
    
    private func makeNextButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(nextButtonPress(_:)), for: .touchUpInside)
        return button
    }
}
