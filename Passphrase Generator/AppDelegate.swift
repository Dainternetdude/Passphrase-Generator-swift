//
//  AppDelegate.swift
//  Passphrase Generator
//
//  Created by Dainternetdude on 2022-04-22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

	let statusItem = NSStatusBar.system.statusItem(withLength: 18.0)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusItem.button?.image = #imageLiteral(resourceName: "StatusBarIcon")
        statusItem.button?.image?.size = NSSize(width: 18.0, height: 18.0)
        
		statusItem.button?.image?.isTemplate = true // makes the image work with light & dark mode
        
		statusItem.button?.target = self
		statusItem.button?.action = #selector(showSettings)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

	@objc func showSettings() {
		let storyBoard = NSStoryboard(name: "Main", bundle: nil)
		guard let vc = storyBoard.instantiateController(withIdentifier: "ViewController") as? StatusBarPopoutViewController else {
			fatalError("Unable to find ViewController in the storyboard")
		}
		
		let popoverView = NSPopover()
		popoverView.contentViewController = vc
		popoverView.behavior = .transient
		popoverView.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
		vc.view.window?.makeKey()
	}
}

