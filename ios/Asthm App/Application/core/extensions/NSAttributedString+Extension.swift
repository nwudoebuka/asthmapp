//
//  NSAttributedString+Extension.swift
//  Asthm App
//
//  Created by Den Matiash on 25.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
{
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

extension NSMutableAttributedString {
    
    func removeTagsAndUnderline() -> NSMutableAttributedString {
        let currentString = self
        let openTag = "<u>"
        let closeTag = "</u>"
        
        while (true) {
            guard let rangeOpenTag = currentString.string.range(of: openTag) else { break }
            guard let rangeCloseTag = currentString.string.range(of: closeTag) else { break }
            
            let indexFirstEntry = rangeOpenTag.upperBound.utf16Offset(in: string) - openTag.count
            let indexLastEntry = rangeCloseTag.lowerBound.utf16Offset(in: string) - 1 - openTag.count
            
            currentString.deleteCharacters(in: NSRange(rangeCloseTag, in: string))
            currentString.deleteCharacters(in: NSRange(rangeOpenTag, in: string))
            
            let range = NSRange(location: indexFirstEntry, length: indexLastEntry - indexFirstEntry + 1)
            
            currentString.addAttribute(.underlineStyle, value: 1, range: range)
        }
        return currentString
    }
}
