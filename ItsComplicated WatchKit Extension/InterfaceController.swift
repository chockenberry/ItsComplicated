//
//  InterfaceController.swift
//  ItsComplicated WatchKit Extension
//
//  Created by Craig Hockenberry on 7/10/21.
//

import WatchKit
import Foundation
import ClockKit

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

	@IBAction func reloadComplications() {
		debugLog()
		
		// NOTE: If needed, you can force all complications to reload immediately. You won't want
		// to expose this functionality in a shipping app, but it can be helpful to see any
		// complications immediately instead of waiting for the timeline entries to refresh.
		
		let complicationServer = CLKComplicationServer.sharedInstance()
		if let activeComplications = complicationServer.activeComplications {
			for complication in activeComplications {
				debugLog("reloading timeline for \(complication)")
				complicationServer.reloadTimeline(for: complication)
			}
		}

	}
	
	func showComplication(identifier: String) {
		popToRootController()
		if (identifier == ComplicationController.complicationOne) {
			pushController(withName: "complicationOne", context: nil)
		}
		else {
			pushController(withName: "complicationTwo", context: nil)
		}
	}
	
}
