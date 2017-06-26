//
//  String+extension.swift
//  SJFeedBack
//
//  Created by 过保的chocolate on 2017/6/25.
//  Copyright © 2017年 gsj. All rights reserved.
//

import Foundation

extension String {
    
    /// 对 subString 的操作
    ///
    /// - Parameter range: 调用者必须保证 range 没有超出范围, 不然会崩溃
    subscript (range: Range<Int>) -> String {
        get {
            if self.characters.count == 0 || self == "" { return "" }
            let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: range.upperBound)
            return self[Range(startIndex..<endIndex)]
        }
        
        set {
            let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: range.upperBound)
            let strRange = Range(startIndex..<endIndex)
            self.replaceSubrange(strRange, with: newValue)
        }
    }
}
