//
//  Node.swift
//  ThreadDown
//
//  Created by Dylan McArthur on 11/13/16.
//  Copyright © 2016 Dylan McArthur. All rights reserved.
//

@objc public class ThreadDownNode: NSObject {
	
	public enum NodeType: Int {
		case title
		case detail
	}
	
	public var startIndex = 0
	public var endIndex = 0
	public var lineNumber = 0
	public var type = NodeType.title
	public var text = ""
	
	public override init() {
		super.init()
	}
	
	public init(startIndex: Int, endIndex: Int) {
		self.startIndex = startIndex
		self.endIndex = endIndex
	}
	
}

extension ThreadDownNode {
	
	public var debugString: String {
		return NSStringFromClass(type(of: self)) + " (\(startIndex), \(endIndex)) ln:\(lineNumber)"
	}
	
}
