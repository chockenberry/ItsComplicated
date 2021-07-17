//
//  WatchSizing.swift
//  StellarMoon WatchKit Extension
//
//  Created by Craig Hockenberry on 12/1/19.
//  Copyright © 2019 The Iconfactory. All rights reserved.
//

import WatchKit

extension WKInterfaceDevice {
	
	enum WatchCase {
		case unknown, case38mm, case40mm, case42mm, case44mm
	}

	func watchCase() -> WatchCase {
		switch screenBounds { // measured in pixels
		case CGRect(origin: .zero, size: CGSize(width: 136, height: 170)):
			return .case38mm
		case CGRect(origin: .zero, size: CGSize(width: 162, height: 197)):
			return .case40mm
		case CGRect(origin: .zero, size: CGSize(width: 156, height: 195)):
			return .case42mm
		case CGRect(origin: .zero, size: CGSize(width: 184, height: 224)):
			return .case44mm
		default:
			return .unknown
		}
	}
	
	func modularSmallSize() -> CGSize? { // in points
		switch watchCase() {
		case .case38mm:
			return CGSize(width: 52 / 2, height: 52 / 2)
		case .case40mm, .case42mm:
			return CGSize(width: 58 / 2, height: 58 / 2)
		case .case44mm:
			return CGSize(width: 64 / 2, height: 64 / 2)
		default:
			return nil
		}
	}

	func circularSmallSize() -> CGSize? { // in points
		switch watchCase() {
		case .case38mm:
			return CGSize(width: 32 / 2, height: 32 / 2)
		case .case40mm, .case42mm:
			return CGSize(width: 36 / 2, height: 36 / 2)
		case .case44mm:
			return CGSize(width: 40 / 2, height: 40 / 2)
		default:
			return nil
		}
	}

	func graphicCircularSize() -> CGSize? { // in points
		switch watchCase() {
		case .case40mm:
			return CGSize(width: 84 / 2, height: 84 / 2)
		case .case44mm:
			return CGSize(width: 94 / 2, height: 94 / 2)
		default:
			return nil
		}
	}

	func graphicCornerSize() -> CGSize? { // in points
		switch watchCase() {
		case .case40mm:
			return CGSize(width: 40 / 2, height: 40 / 2)
		case .case44mm:
			return CGSize(width: 44 / 2, height: 44 / 2)
		default:
			return nil
		}
	}
	
	func extraLargeSize() -> CGSize? { // in points
		switch watchCase() {
		case .case38mm:
			return CGSize(width: 182 / 2, height: 182 / 2)
		case .case40mm, .case42mm:
			return CGSize(width: 203 / 2, height: 203 / 2)
		case .case44mm:
			return CGSize(width: 224 / 2, height: 224 / 2)
		default:
			return nil
		}
	}

}
