//
//  Extensions.swift
//  YourApp
//
//  Created by honza on 07/11/2018.
//  Copyright © 2018 honza. All rights reserved.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY HH:mm"
        let formattedString = dateFormatter.string(from: self)
        return formattedString
    }
}

extension String {
    func getStruckedText() -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
