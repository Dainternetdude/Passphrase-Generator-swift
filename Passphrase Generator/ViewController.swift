//
//  ViewController.swift
//  Passphrase Generator
//
//  Created by Dainternetdude on 2022-04-22.
//

import Cocoa
import Foundation

// should be called MyViewController or something
class ViewController: NSViewController, NSTextFieldDelegate {
	
	
	@IBOutlet weak var outputField: NSTextField!
	@IBOutlet weak var entropyField: NSTextField!
	@IBOutlet weak var uppercaseCheckBox: NSButton!
	@IBOutlet weak var numbersCheckBox: NSButton!
	@IBOutlet weak var symbolsCheckBox: NSButton!
	@IBOutlet weak var strengthSlider: NSSlider!
	@IBOutlet weak var typeSegmentedControl: NSSegmentedControl!

    var includeUppercase = true
    var includeNumbers = true
    var includeSymbols = true
    var strength: PassphraseStrength = .`default`
    var type: PassphraseType = .readable
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
        regeneratePassphrase()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
	
	@IBAction func copyButtonWasPushed(_ sender: Any) {
		NSPasteboard.general.clearContents() // MUST clear contents before setting pasteboard!
		NSPasteboard.general.setString(outputField.stringValue, forType: .string)
	}
	
	@IBAction func regenerateButtonWasPushed(_ sender: Any) {
        regeneratePassphrase()
	}
	
	@IBAction func uppercaseCheckBoxWasToggled(_ sender: Any) {
		switch uppercaseCheckBox.state {
		case NSControl.StateValue.on:
			includeUppercase = true
		case NSControl.StateValue.off:
			includeUppercase = false
			
		default:
			includeUppercase = true
		}
		
        regeneratePassphrase()
	}
	@IBAction func numbersCheckBoxWasToggled(_ sender: Any) {
		switch numbersCheckBox.state {
		case NSControl.StateValue.on:
			includeNumbers = true
		case NSControl.StateValue.off:
			includeNumbers = false
			
		default:
			includeNumbers = true
		}
		
        regeneratePassphrase()
	}
	@IBAction func symbolsCheckBoxWasToggled(_ sender: Any) {
		switch symbolsCheckBox.state {
		case NSControl.StateValue.on:
			includeSymbols = true
		case NSControl.StateValue.off:
			includeSymbols = false
			
		default:
			includeSymbols = true
		}
		
        regeneratePassphrase()
	}
	
	@IBAction func strengthWasChanged(_ sender: Any) {
        switch strengthSlider.integerValue {
        case 0:
            strength = .weak
        case 1:
            strength = .`default`
        case 2:
            strength = .strong
        case 3:
            strength = .veryStrong
            
        default:
            strength = .`default`
        }
		
        regeneratePassphrase()
	}
	
	@IBAction func typeWasChanged(_ sender: Any) {
		switch typeSegmentedControl.selectedSegment {
		case 0:
			type = .dictionary
		case 1:
			type = .readable
		case 2:
			type = .randomized
			
		default:
			type = .readable
		}
		
        regeneratePassphrase()
    }
    
    /*
     basically just rounds the entropy before applying it to the text field
     */
    private func setEntropy(_ entropy: Double) {
        var ent = entropy * 10
        ent = ent.rounded()
        ent /= 10
        entropyField.stringValue = String(ent)
    }
    
    func regeneratePassphrase() {
        outputField.stringValue = generatePassphrase(strength: strength, type: type, uppercase: includeUppercase, numbers: includeNumbers, symbols: includeSymbols)
        setEntropy(getEntropy(strength: strength, type: type, uppercase: includeUppercase, numbers: includeNumbers, symbols: includeSymbols))
    }
}
