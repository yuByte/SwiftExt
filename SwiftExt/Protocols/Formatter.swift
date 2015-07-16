//
//  Formatter.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 2/8/15.
//
//

public protocol Formatter {
    func stringForValue(value: Any) -> String?
    
    func editingStringForValue(value: Any) -> String
    
    func valueForString(string: String) -> (success: Bool, value: Any?, errorDescription: String?)
    
    func isStringValid(string: String) -> (isValid: Bool, newEditingString: String?, errorDescription: String?)
    
    func isStringPartiallyValid(string: String, selectedRange: Range<String.Index>) -> (isValid: Bool, proposedSelectedRange: Range<String.Index>?, errorDescription: String?)
}