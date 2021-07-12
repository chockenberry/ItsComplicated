//
//  TemplateRendering.swift
//  ItsComplicated WatchKit Extension
//
//  Created by Craig Hockenberry on 7/10/21.
//

import Foundation
import ClockKit
import WatchKit

extension ComplicationController {
	
	func drawInfo(in rect: CGRect, index: Int, date: Date, color: UIColor) {
		
		let inset: CGFloat = 10
		let text = rect.insetBy(dx: inset, dy: inset).offsetBy(dx: 0, dy: 0) // dy = 1 to align with battery level, 0 for centered in body

		let fontDescriptor = UIFontDescriptor(fontAttributes: [
			.textStyle : UIFont.TextStyle.title1,
			.traits : [
				UIFontDescriptor.TraitKey.weight : UIFont.Weight.medium,
				UIFontDescriptor.TraitKey.width : NSNumber(-1.0),
			],
		])
		if let roundedDescriptor = fontDescriptor.withDesign(.rounded) {
			let font = UIFont(descriptor: roundedDescriptor, size: 9.0)
			
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center
			
			let attributes = [
				NSAttributedString.Key.font: font,
				NSAttributedString.Key.paragraphStyle: paragraphStyle,
				NSAttributedString.Key.foregroundColor: color,
			]
			
			let string : String
			if index == -2 {
				string = "TEMPLATE"
			}
			else if index == -1 {
				string = "CURRENT"
			}
			else {
				string = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short) + "\nENTRY " + String(index)
			}
			
			// use NSStringDrawingContext to scale text?
			//let context = NSStringDrawingContext()
			//context.minimumScaleFactor = 0.5
			let context: NSStringDrawingContext? = nil
			let computeSize = CGSize(width: rect.size.width, height: rect.size.height)
			let boundingRect = string.boundingRect(with: computeSize, options: .usesLineFragmentOrigin, attributes: attributes, context: context)
			var layoutRect = boundingRect;
			layoutRect.origin = CGPoint(x: text.midX - boundingRect.midX, y: text.midY - boundingRect.midY)
			string.draw(with: layoutRect, options: .usesLineFragmentOrigin, attributes: attributes, context: context)
		}

	}
	
	func comboImage(of size: CGSize, index: Int, date: Date, variation: Int) -> UIImage? {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(size, false, 2.0)

		let foregroundColor = UIColor.white
		let backgroundColor = UIColor.orange

		// there are 100 timeline entries, so scale alpha by that amount
		let alpha = CGFloat(index) / 100.0
		backgroundColor.withAlphaComponent(alpha).set()
		
		let path = UIBezierPath.init(ovalIn: rect)
		path.fill()
		
		if variation == 1 {
			foregroundColor.set()
			path.lineWidth = 2
			path.stroke()
		}
		
		drawInfo(in: rect, index: index, date: date, color: foregroundColor)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}

	func backgroundImage(of size: CGSize, index: Int, date: Date, variation: Int) -> UIImage? {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(size, false, 2.0)

		let backgroundColor = UIColor.orange
		
		// there are 100 timeline entries, so scale alpha by that amount
		let alpha = CGFloat(index) / 100.0
		backgroundColor.withAlphaComponent(alpha).set()
		let path = UIBezierPath.init(ovalIn: rect)
		path.fill()

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}

	func foregroundImage(of size: CGSize, index: Int, date: Date, variation: Int) -> UIImage? {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(size, false, 2.0)

		let foregroundColor = UIColor.white

		if variation == 1 {
			foregroundColor.set()
			let path = UIBezierPath.init(ovalIn: rect)
			path.lineWidth = 2
			path.stroke()
		}
		
		drawInfo(in: rect, index: index, date: date, color: foregroundColor)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}

	func graphicCircularTemplate(index: Int, date: Date, variation: Int) -> CLKComplicationTemplateGraphicCircularImage? {
		guard let size = WKInterfaceDevice.current().graphicCircularSize() else { return nil }
		
		guard let onePieceImage = comboImage(of: size, index: index, date: date, variation: variation) else { return nil }
		let twoPieceImageBackground = backgroundImage(of: size, index: index, date: date, variation: variation)
		let twoPieceImageForeground = foregroundImage(of: size, index: index, date: date, variation: variation)
		
		let tintedImageProvider = CLKImageProvider(onePieceImage: onePieceImage, twoPieceImageBackground: twoPieceImageBackground, twoPieceImageForeground: twoPieceImageForeground)
		
		tintedImageProvider.tintColor = .green
		let imageProvider = CLKFullColorImageProvider(fullColorImage: onePieceImage, tintedImageProvider: tintedImageProvider)

		let template = CLKComplicationTemplateGraphicCircularImage.init(imageProvider: imageProvider)
		return template
	}
}

