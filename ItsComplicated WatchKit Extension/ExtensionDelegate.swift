//
//  ExtensionDelegate.swift
//  ItsComplicated WatchKit Extension
//
//  Created by Craig Hockenberry on 7/10/21.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

	var needsImmediateRefresh = true
	
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

	func applicationDidEnterBackground() {
		
		// NOTE: After the app has launched and is going back into the background, we schedule a refresh that will happen
		// as soon as possible. This lets watchOS know that we need to refresh the complications.
		
		if needsImmediateRefresh {
			scheduleRefresh(immediate: true)
			
			needsImmediateRefresh = false
		}
	}
	
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
		debugLog("backgroundTasks = \(backgroundTasks)")

        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
				
				// NOTE: When a refresh background task occurs, all of the complications are reloaded. This, in turn,
				// causes the complication timeline entries (and their associated template images) to be reloaded. The
				// complication images are created in ComplicationRendering.swift and called by complicationTimelineEntry()
				// when watchOS requests new timeline entries with getTimelineEntries() in the ComplicationController.
				//
				// After the complications are reloaded, this same task is scheduled an hour from now.
				
				reloadComplications()
				scheduleRefresh()

                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(true)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
				if snapshotTask.reasonForSnapshot == .complicationUpdate {
					debugLog("complication timelines were updated")
				}
				
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

}
