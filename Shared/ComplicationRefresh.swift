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
	
	// NOTE: If you previously used the requestedUpdateDidBegin delegate method, it is no longer called.
	//
	// https://forums.developer.apple.com/thread/71501
	// https://forums.developer.apple.com/thread/94827

	func timelineEntryDates(after date: Date, limit: Int) -> [Date] {
		var result = [Date]()
		
		// NOTE: These intervals were chosen to give frequent updates (that will be within 1-5 minutes of accuracy every hour).
		// You can choose other intervals that are more appropriate for the type of information you want to display.
		//
		// Also, the limit parameter comes from the getTimelineEntries() data source method for the complication. It's currently
		// 100, but relying on that fact isn't very forward thinking. Could be more, could be less.
		
		var index = 0
		let count = limit
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

		let variation = (complication.identifier == complicationOne ? 1 : 2) // NOTE: yeah, this should be an enum

		switch complication.family {
		case .graphicCircular:
			if let template = graphicCircularTemplate(index: index, date: date, variation: variation) {
				timelineEntry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
			}
		default:
			// NOTE: This indicates that the complication family isn't supported. Add support by having another case in this switch
			// and generate the appropriate template.
			
			timelineEntry = nil
		}

		return timelineEntry
	}

	func complicationTimelineEntries(complication: CLKComplication, after date: Date, limit: Int) -> [CLKComplicationTimelineEntry] {
		
		var result = [CLKComplicationTimelineEntry]()
		
		// NOTE: This generates 100 Date objects spread out over varying intervals. These dates are then used to
		// create CLKComplicationTimelineEntry objects that are returned to watchOS.
		
		for (index, date) in timelineEntryDates(after: date, limit: limit).enumerated() {
			if let timelineEntry = complicationTimelineEntry(complication: complication, index: index, date: date) {
				result.append(timelineEntry)
			}
		}
		
		return result
	}
	
}
