//
//  SnowEffectViewBuilder.swift
//  SnowEffect
//
//  Created by DADA on 2019/11/24.
//  Copyright © 2019 nalydadad.com. All rights reserved.
//

open class SnowEffectViewBuilder: NSObject {
	public enum SnowType {
		case emoji(string: String, fontSize: CGFloat)
		case circle(size: CGSize, color: UIColor)
		case customImage(image: UIImage)
	}
	
	class open func createView(type: SnowType, size: CGSize) -> UIView {
		let view = UIView(frame: CGRect(origin: .zero, size: size))
		let emitter = createLayer(type: type, size: size)
		view.layer.addSublayer(emitter)
		return view
	}
	
	class open func createLayer(type: SnowType, size: CGSize) -> CAEmitterLayer {
		let emitter = CAEmitterLayer()
		emitter.emitterCells = [emitterCell(type: type, size: size)]
		emitter.frame = CGRect(origin: .zero, size: size)
		emitter.emitterShape = "line"
		emitter.renderMode = "oldestLast"
		emitter.emitterPosition = CGPoint(x: size.width/2, y: 0)
		emitter.emitterSize = size
		return emitter
	}
	
	class private func emitterCell(type: SnowType, size: CGSize) -> CAEmitterCell {
		let lifetime: CGFloat = 20
		let emitterCell = CAEmitterCell()
		emitterCell.birthRate = 5
		emitterCell.lifetime = Float(lifetime)
		emitterCell.lifetimeRange = 1.1
		emitterCell.yAcceleration = size.height/(lifetime*lifetime)
		emitterCell.xAcceleration = 1.1
		emitterCell.velocity = size.height/lifetime
		emitterCell.velocityRange = 10
		emitterCell.emissionLongitude = .pi
		emitterCell.emissionRange = .pi * 0.2
		emitterCell.scaleRange = 0.2
		emitterCell.alphaSpeed = -(1/Float(lifetime))
		emitterCell.alphaRange = 0.5
		renderContents(emitterCell: emitterCell, type: type)
		return emitterCell
	}
	
	class private func renderContents(emitterCell: CAEmitterCell, type: SnowType) {
		switch type {
		case .circle(let size, let color):
			let scale: CGFloat = 0.1
			let extendSize = CGSize(width: size.width/scale, height: size.height/scale)
			let circle = drawCircle(size: extendSize, color: color)
			emitterCell.scale = scale
			emitterCell.contents = circle?.cgImage
		case .customImage(let image):
			emitterCell.contents = image.cgImage
		case .emoji(let string, let fontSize):
			emitterCell.contents = drawString(string: string, fontSize: fontSize)?.cgImage
		}
	}
	
	class private func drawCircle(size: CGSize, color: UIColor) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		guard let ctx = UIGraphicsGetCurrentContext() else {
			UIGraphicsEndImageContext()
			return nil
		}
		ctx.setFillColor(color.cgColor)
		ctx.fillEllipse(in: CGRect(origin: .zero, size: size))
		let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
		return image
	}
	
	class private func drawString(string: String, fontSize: CGFloat) -> UIImage? {
		let size = CGSize(width: fontSize, height: fontSize)
		let canvasRect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
		string.draw(in: canvasRect, withAttributes: [.font: UIFont.systemFont(ofSize: size.width)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
	}
}

