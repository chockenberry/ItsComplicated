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
		
//		reloadComplications()
    }

	@IBAction func reloadComplications() {
		debugLog()
		
		let complicationServer = CLKComplicationServer.sharedInstance()
		if let activeComplications = complicationServer.activeComplications {
			for complication in activeComplications {
				debugLog("reloading timeline for \(complication)")
				complicationServer.reloadTimeline(for: complication)
			}
		}

	}
}
