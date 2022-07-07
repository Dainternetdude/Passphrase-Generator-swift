//
//  PassphraseGenerator.swift
//  Passphrase Generator
//
//  Created by Dainternetdude on 2022-07-06.
//

import Foundation

class PassphraseGenerator {
    
    public enum PassphraseType {
        case dictionary, readable, randomized
    }
    
    public enum PassphraseStrength: Int {
        case weak, defaultt, strong, veryStrong // "default" is a reserved keyword so I use "defaultt"
    }
    
    enum CharType { //TODO refactoring of getRandomCharacter method
        case lowercaseLetter, uppercaseLetter, letter, number, symbol
    }
    
    enum Language { //TODO i18n
        case english
    }
    
    
    private static let lowercaseVowelChars: [Character] = ["a", "e", "i", "o", "u", "y"]
    private static let lowercaseConsonantChars: [Character] = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
    private static let uppercaseVowelChars: [Character] = ["A", "E", "I", "O", "U", "Y"]
    private static let uppercaseConsonantChars: [Character] = ["B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Z"]
    private static var lowercaseChars = lowercaseVowelChars + lowercaseConsonantChars
    private static var uppercaseChars = uppercaseVowelChars + uppercaseConsonantChars
    private static var numberChars: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    private static var symbolChars: [Character] = ["!", "\"", "#", "$", "%", "&", "\'", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "@", "[", "\\", "]", "^", "_", "`", "{", "|", "}", "~"] //TODO allow custom list of symbols

    
    public static func generatePassphrase(strength: PassphraseStrength = PassphraseStrength.defaultt, type: PassphraseType = PassphraseType.randomized, uppercase: Bool = false, numbers: Bool = false, symbols: Bool = false) -> String {
        
        switch type {
        case .dictionary:
            return generateDictionaryPassphrase(strength: strength, uppercase: uppercase, numbers: numbers, symbols: symbols)
        case .readable:
            return generateReadablePassphrase(strength: strength, uppercase: uppercase, numbers: numbers, symbols: symbols)
        case .randomized:
            return generateRandomPassphrase(strength: strength, uppercase: uppercase, numbers: numbers, symbols: symbols)
        }
        
        //calculateEntropy()
    }
    
    private static func generateDictionaryPassphrase(strength: PassphraseStrength = PassphraseStrength.defaultt, uppercase: Bool = false, numbers: Bool = false, symbols: Bool = false) -> String {
        let path = Bundle.main.path(forResource: "wordlist", ofType: "txt")!
        let content = try! String(contentsOfFile: path, encoding: String.Encoding.utf8) // unsafe forced try
        let wordList = content.components(separatedBy: "\n")
        
        let numberOfWords: Int
        switch strength {
        case .weak:
            numberOfWords = 3
        case .defaultt:
            numberOfWords = 4
        case .strong:
            numberOfWords = 5
        case .veryStrong:
            numberOfWords = 6
        }
        
        
        var output = ""
        for i in 1...numberOfWords {
            output += wordList[Int.random(in: 1...wordList.count) - 1]
            output += i != numberOfWords ? " " : ""
        }
        
        if uppercase {
            let char: String = output.first!.uppercased()
            output = char + output.dropFirst()
        }
        if numbers {
            output.append(getRandomCharacter(false, false, true, false))
        }
        if symbols {
            output.append(getRandomCharacter(false, false, false, true))
        }
        
        return output
    }
    
    private static func generateReadablePassphrase(strength: PassphraseStrength = PassphraseStrength.defaultt, uppercase: Bool = false, numbers: Bool = false, symbols: Bool = false) -> String {
        
        var output: String = ""
        var vowelChars = lowercaseVowelChars
        var consonantChars = lowercaseConsonantChars
        
        let blocks: Int
        switch strength {
        case .weak:
            blocks = 2
        case .defaultt:
            blocks = 3
        case .strong:
            blocks = 4
        case .veryStrong:
            blocks = 5
        }
        
        if uppercase {
            vowelChars.append(contentsOf: uppercaseVowelChars)
            consonantChars.append(contentsOf: uppercaseConsonantChars)
        }
        
        for i in 1...blocks {
            for j in 1...6 {
                let char: Character = (j == 2 || j == 5) ? vowelChars.randomElement()! : consonantChars.randomElement()!
                output.append(char)
            }
            output += i != blocks ? "-" : ""
        }
        
        var numPos: Int = -1
        if numbers {
            numPos = Int.random(in: 1...(blocks * 2))
            
            let isFirst = numPos % 2 == 0 ? false : true
            let block = (numPos + 1) / 2
            let rawPos = block * 7 - 2 - isFirst.intValue * 5
            let randomNum = getRandomCharacter(false, false, true, false)
            
            output = String(output.prefix(rawPos)) + String(randomNum) + String(output.dropFirst(rawPos + 1))
        }
        
        if symbols {
            var symbolPos = Int.random(in: 1...(blocks * 2))
            symbolPos -= (symbolPos == numPos).intValue
            symbolPos = symbolPos == 0 ? blocks * 2 : symbolPos
            
            let isFirst = symbolPos % 2 == 0 ? false : true
            let block = (symbolPos + 1) / 2
            let rawPos = block * 7 - 2 - isFirst.intValue * 5
            let randomSymbol = getRandomCharacter(false, false, false, true)
            
            output = String(output.prefix(rawPos)) + String(randomSymbol) + String(output.dropFirst(rawPos + 1))
        }
        
        return output
    }
    
    private static func generateRandomPassphrase(strength: PassphraseStrength = PassphraseStrength.defaultt, uppercase: Bool = false, numbers: Bool = false, symbols: Bool = false) -> String {
                        
        let blocks: Int
        switch strength {
        case .weak:
            blocks = 2
        case .defaultt:
            blocks = 3
        case .strong:
            blocks = 4
        case .veryStrong:
            blocks = 5
        }
        
        var output: String = ""

        for i in 1...blocks {
            for _ in 1...6 { // underscore just makes an anonymous variable (since we never use it its only an iterator)
                let char: Character = getRandomCharacter(true, uppercase, numbers, symbols)
                output.append(char)
            }
            output += i != blocks ? "-" : ""
        }
        
        // add in special characters in case none got in
        if uppercase {
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
        if numbers {
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
        if symbols {
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
    
    private static func getRandomCharacter(_ lowercase: Bool, _ uppercase: Bool, _ numbers: Bool, _ symbols: Bool) -> Character {
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

    public static func getEntropy(strength: PassphraseStrength = PassphraseStrength.defaultt, type: PassphraseType = PassphraseType.randomized, uppercase: Bool = false, numbers: Bool = false, symbols: Bool = false) -> Double {
        
        switch type {
        case .dictionary:
            let numberOfWords: Int
            switch strength {
            case .weak:
                numberOfWords = 3
            case .defaultt:
                numberOfWords = 4
            case .strong:
                numberOfWords = 5
            case .veryStrong:
                numberOfWords = 6
            }
            
            var combos: Double = pow(1000.0,  Double(numberOfWords)) // we choose from a list of 1000 words
            
            if uppercase {
                combos *= 2
            }
            if numbers {
                combos *= Double(numberChars.count)
            }
            if symbols {
                combos *= Double(symbolChars.count)
            }
            
            return log2(combos)
        case .readable:
            var vowelChars = lowercaseVowelChars
            var consonantChars = lowercaseConsonantChars
            
            let blocks: Int
            switch strength {
            case .weak:
                blocks = 2
            case .defaultt:
                blocks = 3
            case .strong:
                blocks = 4
            case .veryStrong:
                blocks = 5
            }
            
            if uppercase {
                vowelChars.append(contentsOf: uppercaseVowelChars)
                consonantChars.append(contentsOf: uppercaseConsonantChars)
            }
            
            let vowelPossibilities = vowelChars.count + (uppercase.intValue * vowelChars.count) // uppercase will be 0 or 1 as it is a boolean
            let consonantPossibilities = consonantChars.count + (uppercase.intValue * consonantChars.count)
            let vowelsTotal = blocks * 2 // two vowels per block
            let consonantsTotal = blocks * 4 // 4 consonants per block
            var combos: Double = pow(Double(vowelPossibilities), Double(vowelsTotal)) * pow(Double(consonantPossibilities), Double(consonantsTotal))
            
            if numbers {
                combos /= Double(consonantPossibilities)
                combos *= Double(numberChars.count)
            }
            
            if symbols {
                combos /= Double(consonantPossibilities)
                combos *= Double(symbolChars.count)
            }
            
            return log2(combos)
        case .randomized:
            let blocks: Int
            switch strength {
            case .weak:
                blocks = 2
            case .defaultt:
                blocks = 3
            case .strong:
                blocks = 4
            case .veryStrong:
                blocks = 5
            }
            
            let possibilities = 26 + uppercase.intValue * 26 + numbers.intValue * 10 + symbols.intValue * 32
            let charsTotal = blocks * 6
            let combos: Double = pow(Double(possibilities), Double(charsTotal))
            
            return log2(combos)
        }
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
