//
//  NavigationSearchBar.swift
//  Maximum
//
//  Created by Ersin Gürsu on 24/01/2017.
//  Ersin Gürsu. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationSearchBarDelegate: class {

    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String, navigationSearchBar: NavigationSearchBar) -> Bool
    func textFieldDidBeginEditing(_ textField: UITextField, navigationSearchBar: NavigationSearchBar)
    func textFieldDidEndEditing(_ textField: UITextField, navigationSearchBar: NavigationSearchBar)
    func textFieldShouldReturn(_ textField: UITextField, navigationSearchBar: NavigationSearchBar) -> Bool
}

class NavigationSearchBar: UIView {

    var textField: UITextField = UITextField()
    var theme: NavBarTheme!

    weak var delegate: NavigationSearchBarDelegate?

    init(frame: CGRect, theme: NavBarTheme, placeHolder:String? = nil) {
        super.init(frame: frame)
        self.theme = theme
        createTextField(frame,placeHolder:placeHolder)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func createTextField(_ frame: CGRect,placeHolder:String? = nil) {

        textField.frame = CGRect(x: 10, y: 0, width: frame.width, height: frame.height)
        textField.backgroundColor = UIColor.clear
        textField.autocorrectionType = .no
        textField.textColor = theme.navigationBarTitleTextColor
        textField.tintColor = theme.navigationBarTitleTextColor
        //textField.font = Theme.Fonts.primaryLine.font
        textField.delegate = self
        textField.placeholder = placeHolder
        textField.tag = navBarSearchTag
        textField.accessibilityIdentifier = "MainSearchBar"
        self.clipsToBounds = true
        self.addSubview(textField)
        textField.becomeFirstResponder()
    }
}

extension NavigationSearchBar : UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {

        delegate?.textFieldDidEndEditing(textField, navigationSearchBar: self)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        delegate?.textFieldDidBeginEditing(textField, navigationSearchBar: self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let del = delegate?.textFieldShouldReturn(textField, navigationSearchBar: self) {
            return del
        }

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let del = delegate?.textField(textField, shouldChangeCharactersInRange: range, replacementString: string, navigationSearchBar: self) {
            return del
        }
        return true
    }
}
