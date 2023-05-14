//
//  BalconyType.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 14.05.23.
//

import Foundation

enum BalconyType: String {
    case glazed = "glazed"
    case nonGlazed = "non-glazed"
    
    var title: String {
        switch self {
            case .glazed:
                return "Glazed balcony"
            case .nonGlazed:
                return "Non-glazed balcony"
        }
    }
}

enum BathroomType: String {
    case combined = "combined"
    case separate = "separate"
    
    var title: String {
        switch self {
            case .combined:
                return "Combined bathroom"
            case .separate:
                return "Separate bathroom"
        }
    }
}
