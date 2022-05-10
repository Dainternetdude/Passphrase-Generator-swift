//
//  ViewController.swift
//  Passphrase Generator
//
//  Created by Dainternetdude on 2022-04-22.
//

import Cocoa

// should be called MyViewController or something
class ViewController: NSViewController {
	
	var uppercase = true
	var numbers   = true
	var symbols   = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		//generatePassPhrase()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

	func generateRandomPassPhrase(_ strength: Int) -> String {
						
		// strength should be 0 to 3 (weak to very strong)
		// therefore the number of "blocks" in the password should be 2 to 5
		let blocks: Int = strength + 2
		
		var output: String = ""

		for i in 1...blocks {
			for _ in 1...6 { // underscore just makes an anonymous variable (since we never use it its only an iterator)
				let char: Character = getRandomCharacter()
				output.append(char)
			}
			if i != blocks {
				output.append("-")
			}
			
			// add in special characters in case none got in
			if uppercase {
				var hasUppercase = false
				for i in "A"..."Z" {
					if output.contains(i) {
						hasUppercase = true
					}
				}
				if !hasUppercase {
					//TODO
				}
			}
			//TODO
		}
	}
	
	func getRandomCharacter() -> Character {
		var range = 26 // all lowercase english letters
		if uppercase {
			range += 26 // all uppercase english letters
		}
		if numbers {
			range += 10
		}
		if symbols {
			range += 32
		}
		
		var num = Int.random(in: 1...range)
		num += 0x20 // align num to beginning of symbols (right after spacebar)
		
		if !uppercase {
			if ("A"..."Z").contains(num.toChar()) {
				return getRandomCharacter()
			} else {
				return num.toChar()
			}
		}
		if !numbers {
			if ("0"..."9").contains(num.toChar()) {
				return getRandomCharacter()
			} else {
				return num.toChar()
			}
		}
		if !symbols {
			if !("A"..."Z").contains(num.toChar())
				&& !("a"..."z").contains(num.toChar())
				&& !("0"..."9").contains(num.toChar()) {
				return getRandomCharacter()
			} else {
				return num.toChar()
			}
		}
		return num.toChar()
	}
}

// extension to Int class
extension Int {
	// returns the int as a char (duh)
	func toChar() -> Character {
		// u have to do some janky stuff because swift
		return Character(UnicodeScalar(self)!)
		// contains a force unwrap which i should fix later but whatever
	}
}
