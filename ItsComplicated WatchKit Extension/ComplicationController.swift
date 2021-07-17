//
//  ComplicationController.swift
//  ItsComplicated WatchKit Extension
//
//  Created by Craig Hockenberry on 7/10/21.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
	// NOTE: This app supports two complications that are identified using these strings:
	let complicationOne = "complication1"
	let complicationTwo = "complication2"

    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
			
			// NOTE: The displayName is shown in the complication picker along with the template image generated in
			// getLocalizableSampleTemplate().
            
			CLKComplicationDescriptor(identifier: complicationOne, displayName: "It’s Complicated One", supportedFamilies: [CLKComplicationFamily.graphicCircular]),
			CLKComplicationDescriptor(identifier: complicationTwo, displayName: "It’s Complicated Two", supportedFamilies: [CLKComplicationFamily.graphicCircular])
           
			// Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        //handler(nil)
		handler(Date.distantFuture)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
		let date = Date()
		debugLog("timeline: date = \(date), complication.family = \(complication.family.rawValue)")

		let timelineEntry = complicationTimelineEntry(complication: complication, index: -1, date: date)

        // Call the handler with the current timeline entry
		handler(timelineEntry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
		debugLog("timeline: date = \(date), limit = \(limit), complication.family = \(complication.family.rawValue)")
		
		let timelineEntries = complicationTimelineEntries(complication: complication, after: date, limit: limit)
		handler(timelineEntries)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
		var template: CLKComplicationTemplate?
		
		// NOTE: The variation between the two complications isn't very interesting - the first one has a ring, the other does not.
		let variation = (complication.identifier == complicationOne ? 1 : 2)

		switch complication.family {
		case .graphicCircular:
			debugLog("creating graphicCircular template")
			// image that shows up in complication picker
			template = graphicCircularTemplate(index: -2, date: Date(), variation: variation)
		default:
			// no timeline entry
			template = nil
		}
		
		handler(template)
    }
}
