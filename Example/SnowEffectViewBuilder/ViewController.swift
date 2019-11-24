//
//  ViewController.swift
//  SnowEffectViewBuilder
//
//  Created by DADA on 11/24/2019.
//  Copyright (c) 2019 DADA. All rights reserved.
//

import UIKit
import SnowEffectViewBuilder

class ViewController: UIViewController {
	private let toggle = UISwitch()
	
	override func viewDidLoad() {
		setupToggle()
		let emitter = SnowEffectViewBuilder.createLayer(
			type: .circle(size: CGSize(width: 1.0, height: 1.0), color: UIColor(white: 0.85, alpha: 1.0)),
			size: self.view.bounds.size)
		self.view.layer.addSublayer(emitter)
	}
	
	private func setupToggle() {
		self.view.addSubview(toggle)
		self.toggle.addTarget(self, action: #selector(setupSnowEffect(sender:)), for: .valueChanged)
		self.toggle.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			toggle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
			toggle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)])
	}
	
	@objc func setupSnowEffect(sender: UISwitch) {
		UIView.animate(withDuration: 0.4) {
			self.view.backgroundColor = sender.isOn ? UIColor.black : UIColor.white
		}
	}
}

