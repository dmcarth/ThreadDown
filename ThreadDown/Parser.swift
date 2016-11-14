//
//  Parser.swift
//  ThreadDown
//
//  Created by Dylan McArthur on 11/13/16.
//  Copyright © 2016 Dylan McArthur. All rights reserved.
//

@objc public class ThreadDownParser: NSObject {
	
	var data = [UInt16]()
	
	var result = [ThreadDownNode]()
	
	var lineNumber = 0
	
	var charNumber = 0
	
	var endOfLineCharNumber = 0
	
	public init(_ string: String) {
		self.data = [UInt16](string.utf16)
		endOfLineCharNumber = self.data.count
	}
	
	public class func parse(_ string: String) -> [ThreadDownNode] {
		let parser = ThreadDownParser(string)
		return parser.parse()
	}
	
	public func parse() -> [ThreadDownNode] {
		result = []
		lineNumber = 0
		charNumber = 0
		endOfLineCharNumber = 0
		
		parseLines()
		
		return result
	}
	
}

extension ThreadDownParser {
	
	func parseLines() {
		
		let endCount = data.count
		
		while charNumber < endCount {
			
			endOfLineCharNumber = charNumber
			while endOfLineCharNumber < endCount {
				endOfLineCharNumber += 1
				if scanForLineEnding(atIndex: endOfLineCharNumber-1) {
					break
				}
			}
			
			lineNumber += 1
			
			processLine()
			
			charNumber = endOfLineCharNumber
			
		}
		
	}
	
	func processLine() {
		// Initialize node
		let block = ThreadDownNode(startIndex: charNumber, endIndex: endOfLineCharNumber)
		block.lineNumber = lineNumber
		
		// Determine type
		let wc = scanForFirstNonspace(startingAtIndex: charNumber)
		switch (wc - charNumber) {
		case 0:
			block.type = .title
		default:
			block.type = .detail
		}
		
		// Trim whitespace
		var i = endOfLineCharNumber
		while i > charNumber {
			if scanForWhitespace(atIndex: i-1) {
				i -= 1
				continue
			}
			
			break
		}
		
		// Set text
		let bytes = Array(data[wc..<i])
		block.text = String(utf16CodeUnits: bytes, count: bytes.count)
		
		// Finish
		result.append(block)
	}
	
}

// Scanners
extension ThreadDownParser {
	
	func scanForLineEnding(atIndex i: Int) -> Bool {
		let c = data[i]
		
		return c == 0x000a || c == 0x000d // '\n', '\r'
	}
	
	func scanForWhitespace(atIndex i: Int) -> Bool {
		let c = data[i]
		
		// ' ', '\t', newline
		return c == 0x0020 || c == 0x0009 || scanForLineEnding(atIndex: i)
	}
	
	func scanForFirstNonspace(startingAtIndex i: Int) -> Int {
		var j = i
		
		while j < endOfLineCharNumber {
			if scanForWhitespace(atIndex: j) {
				j += 1
			} else {
				return j
			}
		}
		
		return j
	}
	
}


