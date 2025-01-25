//
//  Typography.swift
//  News
//
//  Created by Madhu on 25/01/25.
//

import Foundation
import SwiftUI

// A struct containing typography-related constants and helper methods for fonts.
struct Typography {
    enum FontSize {
        static let subHeadline: CGFloat = 12
        static let headline: CGFloat = 16
        static let title: CGFloat = 20
    }

    enum FontWeight {
        static let regular = Font.Weight.regular
        static let bold = Font.Weight.bold
        static let semibold = Font.Weight.semibold
    }

    static func headlineFont() -> Font {
        return Font.system(size: FontSize.headline, weight: FontWeight.semibold, design: .default)
    }

    static func subHeadlineFont() -> Font {
        return Font.system(size: FontSize.subHeadline, weight: FontWeight.regular, design: .default)
    }

    static func titleFont() -> Font {
        return Font.system(size: FontSize.title, weight: FontWeight.bold, design: .default)
    }
}
