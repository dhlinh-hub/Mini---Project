//
//  StringUntils.swift
//  MovieApp
//
//  Created by Ishipo on 07/09/2021.
//
import Foundation

extension String {
    public func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    var isBlank: Bool {
        return self.trim().isEmpty
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func removeAllWhitespaces() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined(separator: "%20")
    }
    
    func removeAccents() -> String {
        var string = self

        /// `.folding(options:locale:)` won't work for these 2 characters
        if string.contains("đ") {
            string = string.replacingOccurrences(of: "đ", with: "d")
        }
        if string.contains("Đ") {
            string = string.replacingOccurrences(of: "Đ", with: "D")
        }
        if string.contains("["){
            string = string.replacingOccurrences(of: "[", with: "")
        }
        if string.contains("]"){
            string = string.replacingOccurrences(of: "]", with: "")
        }
      
        
        /// use `.diacriticInsensitive` to remove diacritic marks
        return string.folding(options: [.diacriticInsensitive], locale: Locale(identifier: "en_US_POSIX"))
    }
    
    func matches(_ pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES[c] %@", pattern).evaluate(with: self)
    }
    
    var removeCurrency: String {
        if (self.isEmpty) {
            return "0"
        }
        return self.replacingOccurrences(of: ".", with: "").removeAllWhitespaces()
    }
    
    var doubleVal: Double {
        return Double(self.removeCurrency) ?? 0
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        return nil
    }
}

extension Optional where Wrapped == String {
    var isNilOrBlank: Bool {
        guard let str = self else {
            return true
        }
        return str.isBlank
    }
    
    var isNilOrEmpty: Bool {
        guard let str = self else {
            return true
        }
        return str.isEmpty
    }
}

extension Substring {
    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}



