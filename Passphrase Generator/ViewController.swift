//
//  ViewController.swift
//  Passphrase Generator
//
//  Created by Dainternetdude on 2022-04-22.
//

import Cocoa

// should be called MyViewController or something
class ViewController: NSViewController, NSTextFieldDelegate {
	
	enum PassPhraseType {
		case dictionary, readable, random
	}
	
	@IBOutlet weak var outputField: NSTextField!
	@IBOutlet weak var entropyField: NSTextField!
	var entropy: Int = 0
	@IBOutlet weak var uppercaseCheckBox: NSButton!
	var includeUppercase = true
	@IBOutlet weak var numbersCheckBox: NSButton!
	var includeNumbers = true
	@IBOutlet weak var symbolsCheckBox: NSButton!
	var includeSymbols = true
	@IBOutlet weak var strengthSlider: NSSlider!
	var strength: Int = 1
	@IBOutlet weak var typeSegmentedControl: NSSegmentedControl!
	var type: PassPhraseType = .readable
	
	var lowercaseChars = [Character]()
	var uppercaseChars = [Character]()
	var numberChars = [Character]()
	var symbolChars = [Character]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		for asciival in 0x61...0x7A {
			lowercaseChars.append(asciival.toChar())
		}
		for asciival in 0x41...0x5A {
			uppercaseChars.append(asciival.toChar())
		}
		for asciival in 0x30...0x39 {
			numberChars.append(asciival.toChar())
		}
		for asciival in 0x21...0x2F {
			symbolChars.append(asciival.toChar())
		}
		for asciival in 0x3A...0x40 {
			symbolChars.append(asciival.toChar())
		}
		for asciival in 0x5B...0x60 {
			symbolChars.append(asciival.toChar())
		}
		for asciival in 0x7B...0x7E {
			symbolChars.append(asciival.toChar())
		}
		
		generatePassphrase(strength)
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
		generatePassphrase(strength)
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
		
		generatePassphrase(strength)
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
		
		generatePassphrase(strength)
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
		
		generatePassphrase(strength)
	}
	
	@IBAction func strengthWasChanged(_ sender: Any) {
		strength = strengthSlider.integerValue
		
		generatePassphrase(strength)
	}
	
	@IBAction func typeWasChanged(_ sender: Any) {
		switch typeSegmentedControl.selectedSegment {
		case 0:
			type = .dictionary
		case 1:
			type = .readable
		case 2:
			type = .random
			
		default:
			type = .readable
		}
		
		generatePassphrase(strength)
	}
	
	func generatePassphrase(_ strength: Int) {
		
		switch type {
		case .dictionary:
			outputField.stringValue = generateDictionaryPassphrase(strength)
		case .readable:
			outputField.stringValue = generateReadablePassphrase(strength)
		case .random:
			outputField.stringValue = generateRandomPassphrase(strength)
		}
		
		//calculateEntropy()
	}
	
	func generateDictionaryPassphrase(_ strength: Int) -> String {
		// generate dictionary-style passphrase
		return lowercaseChars + "\n"
		+ uppercaseChars + "\n"
		+ numberChars + "\n"
		+ symbolChars
	}
	
	func generateReadablePassphrase(_ strength: Int) -> String {
		// generate readable passphrase
		return "hello readable world"
	}
	
	func generateRandomPassphrase(_ strength: Int) -> String {
						
		// strength should be 0 to 3 (weak to very strong)
		// therefore the number of "blocks" in the password should be 2 to 5
		let blocks: Int = strength + 2
		
		var output: String = ""

		for i in 1...blocks {
			for _ in 1...6 { // underscore just makes an anonymous variable (since we never use it its only an iterator)
				let char: Character = getRandomCharacter(true, includeUppercase, includeNumbers, includeSymbols)
				output.append(char)
			}
			if i != blocks {
				output.append("-")
			}
		}
		
		// add in special characters in case none got in
		if includeUppercase {
			var hasUppercase = false
			
			for i in uppercaseChars {
				if output.contains(i) {
					hasUppercase = true
				}
			}
			
			if !hasUppercase {
				output.append(getRandomCharacter(false, true, false, false))
			}
		}
		if includeNumbers {
			var hasNumbers = false
			
			for i in numberChars {
				if output.contains(i) {
					hasNumbers = true
				}
			}
			
			if !hasNumbers {
				output.append(getRandomCharacter(false, false, true, false))
			}
		}
		if includeSymbols {
			var hasSymbols = false
			
			for i in symbolChars {
				if output.contains(i) {
					hasSymbols = true
				}
			}
			
			if !hasSymbols {
				output.append(getRandomCharacter(false, false, false, true))
			}
		}
		
		return output
	}
	
	func getRandomCharacter(_ lowercase: Bool, _ uppercase: Bool, _ numbers: Bool, _ symbols: Bool) -> Character {
		let num = Int.random(in: 0x21...0x7E) // '!' to '~' (all non-formatting characters on US keyboard except space
												// AKA lowercase + uppercase + numbers + symbols
		
		if !lowercase && lowercaseChars.contains(num.toChar()) {
				return getRandomCharacter(lowercase, uppercase, numbers, symbols)
		}
		if !uppercase && uppercaseChars.contains(num.toChar()) {
				return getRandomCharacter(lowercase, uppercase, numbers, symbols)
		}
		if !numbers && numberChars.contains(num.toChar()) {
				return getRandomCharacter(lowercase, uppercase, numbers, symbols)
		}
		if !symbols && symbolChars.contains(num.toChar()) {
				return getRandomCharacter(lowercase, uppercase, numbers, symbols)
		}
		return num.toChar()
	}
}

// extension to integer class
extension Int {
	// returns the int as a char (duh)
	func toChar() -> Character {
		// u have to do some janky stuff because swift
		return Character(UnicodeScalar(self)!)
		// contains a force unwrap which i should fix later but whatever
	}
	
	// convert int to boolean C-style
	var boolValue: Bool {
		return self != 0
	}
}

// extension to boolean class
extension Bool {
	// convert boolean to int C-style
	// returns 1 if true, 0 if false
	var intValue: Int {
		return self ? 1 : 0
	}
}
