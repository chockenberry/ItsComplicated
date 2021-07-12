//
//  RefreshTaskManager.swift
//  StellarEarth WatchKit Extension
//
//  Created by Craig Hockenberry on 11/30/19.
//  Copyright © 2019 The Iconfactory. All rights reserved.
//

import WatchKit
import ClockKit
import Foundation

// helpful links:
// https://code.tutsplus.com/tutorials/an-introduction-to-clockkit--cms-24247
// https://stackoverflow.com/a/54557763/132867


extension ExtensionDelegate {
	
	func scheduleRefresh(immediate: Bool = false) {
		let preferredDate: Date
		if immediate {
			preferredDate = Date()
		}
		else {
			let updateTimeInterval: TimeInterval = 1 * 60 * 60 // 1 hour
			preferredDate = Date(timeIntervalSinceNow: updateTimeInterval)
		}
		
		WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: preferredDate, userInfo: nil) { (error) in
		   debugLog("timeline: scheduled preferredDate = \(preferredDate)")
		   if error != nil {
			   releaseLog("error = \(String(describing: error))")
		   }
		}
	}
	
	func reloadComplications() {
		let complicationServer = CLKComplicationServer.sharedInstance()
		if let activeComplications = complicationServer.activeComplications {
			for complication in activeComplications {
				debugLog("timeline: reload timeline for complication.family = \(complication.family.rawValue)")
				complicationServer.reloadTimeline(for: complication)
			}
		}
	}
	
}

extension ComplicationController {
	
	// requestedUpdateDidBegin delegate method is no longer called
	// https://forums.developer.apple.com/thread/71501
	// https://forums.developer.apple.com/thread/94827

	func timelineEntryDates(after date: Date) -> [Date] {
		var result = [Date]()
		
		var index = 0
		let count = 100
		var interval: TimeInterval = 0
		while index < count {
			switch index {
			case 0...10:			// 10 at
				interval += 1 * 60	// 		1 minute
			case 10...30:			// 20 at
				interval += 5 * 60	// 		5 minutes
			case 30...70:			// 40 at
				interval += 15 * 60	// 		15 minutes
			default:				// 30 at
				interval += 60 * 60	// 		1 hour
			}
			
			let timelineEntryDate = date.advanced(by: interval)
			result.append(timelineEntryDate)
			index += 1
		}
		
		return result
	}

	func complicationTimelineEntry(complication: CLKComplication, index: Int, date: Date) -> CLKComplicationTimelineEntry? {
		var timelineEntry: CLKComplicationTimelineEntry?

		debugLog("timeline: entry for date = \(date), complication.family = \(complication.family.rawValue)")

		let variation = (complication.identifier == "complicationOne" ? 1 : 2)

		switch complication.family {
		case .graphicCircular:
			//debugLog("creating graphicCircular timelineEntry")
			if let template = graphicCircularTemplate(index: index, date: date, variation: variation) {
				timelineEntry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
			}
		default:
			// no timeline entry
			timelineEntry = nil
		}

		return timelineEntry
	}

	func complicationTimelineEntries(complication: CLKComplication, after date: Date) -> [CLKComplicationTimelineEntry] {
		
		var result = [CLKComplicationTimelineEntry]()
		
		for (index, date) in timelineEntryDates(after: date).enumerated() {
			if let timelineEntry = complicationTimelineEntry(complication: complication, index: index, date: date) {
				result.append(timelineEntry)
			}
		}
		
		return result
	}
	
}
