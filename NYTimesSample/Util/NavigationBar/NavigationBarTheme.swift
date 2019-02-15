//
//  NavigationBarTheme.swift
//  Maximum
//
//  Created by Ersin Gürsu on 23/01/2017.
//  Ersin Gürsu. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationBarThemeProtocol {

    var navigationBarBackImageName: String { get }
    var navigationBarTitleTextColor: UIColor { get }
    var navigationBarTintColor: UIColor { get }
    var navigationTransculent: Bool { get }
    var navigationBarStyle: UIBarStyle { get }
    var navigationBarItemTintColor: UIColor { get }

}

enum NavBarTheme: NavigationBarThemeProtocol {

    case dark
    case light
    case clear
    case closeLight

    var navigationBarBackImageName: String {

        switch self {
        case .dark:
            return "menu"
        case .light:
            return "lightBack"
        case .clear:
            return "gray_back"
        case .closeLight:
            return "iconBackgroundClearWhite"
            

        }
    }

    var navigationBarStyle: UIBarStyle {

        switch self {
        case .dark, .light, .closeLight:
            return .default
        default:
            return .default
        }
    }

    var navigationTransculent: Bool {

        switch self {
        case .dark, .light, .closeLight:
            return false
        default:
            return true
        }
    }

    var navigationBarTitleTextColor: UIColor {

        switch self {
        case .dark:
            return UIColor.white
        case .light, .clear, .closeLight:
            return Theme.Colors.navigationTitleColor.color
        }
    }

    var navigationBarTintColor: UIColor {

        switch self {
        case .dark:
            return Theme.Colors.navigationBarTintColor.color
        case .light, .closeLight:
            return UIColor.white
        case .clear:
            return UIColor.clear

        }
    }

    var navigationBarItemTintColor: UIColor {

        switch self {
        case .dark:
            return UIColor.white
        case .light, .closeLight:
            return Theme.Colors.navigationBarTintColor.color
        case .clear:
            return UIColor.white

        }
    }

}

enum RightBarItem: Equatable {

    static func ==(lhs: RightBarItem, rhs: RightBarItem) -> Bool {
        switch (lhs, rhs) {
        case (.search, .search):
            return true
        case (let .onlyText(text1), let .onlyText(text2)):
            return text1 == text2
        default:
            return false
        }
    }
    case search
    case onlyText(String)
    case more

    var selectorFuncName: String {

        switch self {
        case .search:
            return "searchPress"
        case .onlyText(_):
            return "rightItemRegularPressed"
        case .more:
            return "rightItemMorePressed"
        }
    }

    var title: String {

        switch self {
        case  .search,.more:
            return ""
        case .onlyText(let title):
            return title
        }
    }

    var imageName: String {

        switch self {
        case .search:
            return "search"
        case .more:
            return "more"
        default:
            return ""
        }
    }

}
