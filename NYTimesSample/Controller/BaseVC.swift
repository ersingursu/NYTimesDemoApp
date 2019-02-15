//
//  BaseVC.swift
//  TestBaseViewController
//
//  Created by Haluk Ates on 05/09/16.
//  Copyright © 2016 ASG. All rights reserved.
//

import UIKit
import Foundation

public enum LoginResultType {
    case failure
    case success
}

let navbarH: CGFloat = 44.0
let navBarSearchTag = 7777

class NavSearchModel{
    var text: String?
    var searchIsActive: Bool{
        return text != nil
    }
    var filterCode: String?
    var defaultState: [RightBarItem] = [RightBarItem]()
    
    private init(){}

}

@objc
class BaseVC: UIViewController, UIScrollViewDelegate {
	var baseScrollView: UIScrollView?

    lazy var rightButtonItemList = [RightBarItem]()

    var theme: NavBarTheme = .dark
    var viewBarStatus: UIView?
    var googleAnalyticsScreenName: String?
	var rightButton: String?
	var titleText: String?
    var centerTitleText: String?
	var rightButtonText: String?
    var noContentText: String?
	var secondTitleText: String?
    var rightButtonOnlyText: String?
    var viewBackgroundColor =  Theme.Colors.white.color
    var viewCurtain: UIView?
    lazy var searchIsActive: Bool = false
    var searchBar: NavigationSearchBar?
    var shouldShadowAdded: Bool = true
    
    var hidesBackButton: Bool = false
    var searchPlaceholder: String?

    
    fileprivate let whiteSearchImage = UIImage(named: "searchWhite")

    deinit {
        let type = Swift.type(of: self)
      
        NotificationCenter.default.removeObserver(self)
    }

    
	override func viewDidLoad() {
		super.viewDidLoad()
	}

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeStatusbar()
    }

    func calculateNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.navigationBarTitleTextColor]
        navigationController?.navigationBar.barTintColor = theme.navigationBarTintColor
        navigationController?.navigationBar.isTranslucent = theme.navigationTransculent
    }

    func rightButtonItemRefresh() {
        addRightButton()
    }

    func leftBarButtonItem()
    {
        if hidesBackButton
        {
            let button: UIButton = UIButton(type: .custom)
                    button.setImage(nil, for: .normal)
                  navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        }else
        {
            let button: UIButton = UIButton(type: .custom)
            let image = UIImage(named: theme.navigationBarBackImageName)
            if let backImage = image {
                button.setImage(backImage, for: .normal)
                button.addTarget(self, action: #selector(BaseVC.leftItemAction), for: .touchUpInside)
                button.frame = CGRect(x: 0, y: 0, width: backImage.size.width, height: backImage.size.height)
                button.clipsToBounds = true
            }
             navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        }
       
    }

    func initBar() {
        viewBarStatus = UIView(frame:CGRect(x: 0, y: -20, width: UIScreen.main.bounds.size.width, height: 20))
        viewBarStatus!.backgroundColor = UIColor(red: 255 / 255, green: 13 / 255, blue: 134 / 255, alpha: 1.0)
//        if IS_IPHONE_X {
//             viewBarStatus!.backgroundColor = UIColor.clear
//            changeStatusBar()
//        }

        navigationController?.navigationBar.addSubview(self.viewBarStatus!)
        addShadowToNavBar()
    }

//    fileprivate func changeStatusBar() {
//        if IS_IPHONE_X
//        {
//            if NavBarTheme.light == theme
//            {
//                UIApplication.shared.statusBarStyle = .default
//            } else {
//                UIApplication.shared.statusBarStyle = .lightContent
//            }
//        }
//    }
    
    func createStatusbar() {
        switch theme {
        case .light, .clear, .closeLight:
            initBar()
        default:
            break
        }
    }

    func removeStatusbar() {
        viewBarStatus?.removeFromSuperview()
        removeShadowToNavBar()
    }

    func removeShadowToNavBar() {
        navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        navigationController?.navigationBar.layer.shadowRadius = 0.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.0
    }

    func addShadowToNavBar() {
        
        if shouldShadowAdded {
            
            navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
            navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            navigationController?.navigationBar.layer.shadowRadius = 2.0
            navigationController?.navigationBar.layer.shadowOpacity = 0.1
            
        }
    }

    func addRightButton() {
        
        if searchIsActive {
            return
        }
        
        var rightItems = [UIBarButtonItem]()
        for item in rightButtonItemList {
            let button: UIButton = UIButton(type: .custom)
            let image = UIImage(named: item.imageName)
            if let backImage = image {
                button.addTarget(self, action: NSSelectorFromString(item.selectorFuncName), for: .touchUpInside)
                button.frame = CGRect(x: 0, y: 0, width: backImage.size.width, height: backImage.size.height)
                button.clipsToBounds = true
                button.tintColor = theme.navigationBarItemTintColor
                button.setImage(backImage, for: .normal)
                rightItems.append(UIBarButtonItem(customView: button))
            }
        }
        navigationItem.setRightBarButtonItems(rightItems, animated: true)
    }

    @objc func searchBarWillPassive() {
        searchIsActive = false
        navigationSearchBarRemoved()
        addRightButton()
        createTitleView()
    }

    func addSearchbar() {
        searchBarWillActive()
        searchBar = NavigationSearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44), theme: theme, placeHolder:searchPlaceholder)
        searchBar?.delegate = self
        navigationItem.titleView = searchBar
    }
    
    final func searchBarText(searchModel: NavSearchModel?){
        guard let model = searchModel else {
            searchBarWillPassive()
            return
            
        }
        if model.searchIsActive {
            addSearchbar()
            searchBar?.textField.text = model.text
            searchBarResign()
        }else{
            searchBarWillPassive()
        }
    }
    
    final func searchBarResign(){
        searchBar?.textField.resignFirstResponder()
    }

    func searchBarWillActive() {
        searchIsActive = true
        navigationItem.setRightBarButtonItems(nil, animated: true)
        let btn = UIBarButtonItem(image: UIImage(named: "close"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(BaseVC.searchBarWillPassive))
        btn.tintColor = theme.navigationBarItemTintColor
        navigationItem.setRightBarButton(btn, animated: true)
    }

    func delay(_ delay: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

    func rightItemFilterPressed() {}
    func rightItemSearchPressed() {}
    func rightItemRegularPressed() {}
    @objc func rightItemMorePressed() {}
    func dismissPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc final func searchPress() {
        addSearchbar()
        rightItemSearchPressed()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        centerTitle()
		
		view.backgroundColor = viewBackgroundColor
        calculateNavigationBar()
        createStatusbar()
        addRightButton()
        leftBarButtonItem()

		if (rightButton != nil) {
			self.navigationItem.rightBarButtonItem = rightBarButtonItem()
		} else if rightButtonText != nil {
			self.navigationItem.rightBarButtonItem = rightBarButtonItemWithText()
		} else if rightButtonOnlyText != nil {
            self.navigationItem.rightBarButtonItem = rightBarButtonItemOnlyText()
        }

        createTitleView()
        //changeStatusBar()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
	}
    
    func centerTitle() {
        
        if centerTitleText != nil {
            
            let centerLabel = UILabel.init(frame: CGRect(x:0, y:0, width: 200, height: navbarH))
            //centerLabel.font = UIFont(name: syste, size: 14)
            centerLabel.textColor = theme.navigationBarTitleTextColor
            centerLabel.backgroundColor = UIColor.clear
            centerLabel.textAlignment = .center
            centerLabel.text = centerTitleText
            navigationItem.titleView = centerLabel
            centerLabel.adjustsFontSizeToFitWidth = true
        }
        
    }

    func createTitleView() {
        if searchIsActive {
            return
        }
        
        if secondTitleText != nil {
            navigationItem.titleView = doubleTitleView()
        } else {
            if titleText != nil {
                navigationItem.titleView = titleView()
            }
        }

        navigationItem.titleView?.accessibilityIdentifier = "navigationItem.titleView"
    }

	// MARK: - Navigation Bar Apparence
	func rightBarButtonItem() -> UIBarButtonItem {
		let button: UIButton = UIButton.init(type: .custom)
		let image = UIImage(named: rightButton!)
		if image != nil {
			button.setImage(image, for: .normal)
			button.addTarget(self, action: #selector(BaseVC.rightItemAction), for: .touchUpInside)
			button.frame = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
		}
		return UIBarButtonItem(customView: button)
	}

    func rightBarButtonItemOnlyText() -> UIBarButtonItem {
        let button: UIButton = UIButton.init(type: .custom)
        button.setTitle(rightButtonOnlyText!, for: .normal)
        //button.titleLabel?.font = Theme.Fonts.navigationBarTitle.font
        button.titleLabel?.textAlignment = NSTextAlignment.right
        button.titleLabel?.textColor = theme.navigationBarTitleTextColor
        button.addTarget(self, action: #selector(BaseVC.rightItemAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 44)
        return UIBarButtonItem(customView: button)
    }

	func rightBarButtonItemWithText() -> UIBarButtonItem {
		let navBarCenterView = UIView.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
		navBarCenterView.backgroundColor = UIColor.clear
		let centerLabel = UILabel.init(frame: CGRect(x: -5, y: 0, width: UIScreen.main.bounds.width, height: 44))
		//centerLabel.font = Theme.Fonts.secondaryLine.font
		centerLabel.textColor = theme.navigationBarTitleTextColor
		centerLabel.backgroundColor = UIColor.clear
		centerLabel.text = rightButtonText
		navBarCenterView.addSubview(centerLabel)

		let item = UIBarButtonItem.init(customView: navBarCenterView)
		return item
	}

    func createTitleLabel() -> UILabel {

        let centerLabel = UILabel.init(frame: CGRect(x: 11, y: 0, width: UIScreen.main.bounds.width, height: navbarH))
        //centerLabel.font = Theme.Fonts.navigationBarTitle.font
        centerLabel.textColor = theme.navigationBarTitleTextColor
        centerLabel.backgroundColor = UIColor.clear
        centerLabel.text = titleText
        centerLabel.minimumScaleFactor = 0.5
        centerLabel.textAlignment = NSTextAlignment.left
        centerLabel.accessibilityIdentifier = "CenterTitleLabelIdentifier"
        return centerLabel
    }

	func titleView() -> UIView {
		let navBarCenterView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: navbarH))
		navBarCenterView.backgroundColor = UIColor.clear
		navBarCenterView.clipsToBounds = true
		navBarCenterView.addSubview(createTitleLabel())
		return navBarCenterView
	}

	func doubleTitleView() -> UIView {
		let navBarCenterView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: navbarH))
		navBarCenterView.backgroundColor = UIColor.clear
		navBarCenterView.clipsToBounds = true
		let centerLabel = UILabel.init(frame: CGRect(x: 11, y: -8, width: UIScreen.main.bounds.width, height: navbarH))
		centerLabel.font = UIFont(name: "ProximaNova-Medium", size: 14)
		centerLabel.textColor = theme.navigationBarTitleTextColor
		centerLabel.backgroundColor = UIColor.clear
        centerLabel.minimumScaleFactor = 0.5
		centerLabel.text = titleText
        centerLabel.accessibilityIdentifier = "CenterTitleLabelIdentifier"
		navBarCenterView.addSubview(centerLabel)
		let secondLabel = UILabel.init(frame: CGRect(x: 11, y: 9, width: UIScreen.main.bounds.width, height: navbarH))
		secondLabel.font = UIFont(name: "ProximaNova-Regular", size: 10)
		secondLabel.textColor = theme.navigationBarTitleTextColor
		secondLabel.backgroundColor = UIColor.clear
		secondLabel.text = secondTitleText
        secondLabel.minimumScaleFactor = 0.5
        secondLabel.accessibilityIdentifier = "SecondTitleLabelIdentifier"
		navBarCenterView.addSubview(secondLabel)
		return navBarCenterView
	}

	// MARK: - Navigation Bar Actions

	@objc func leftItemAction() {
        navigationController?.popViewController(animated: true)
	}

	@objc func rightItemAction() {}
    
}

// MARK: Service Process

public enum AuthenticationType {
    case yes
    case semi
    case no

}

enum ServiceResultCodeType {
    case exit
    case `continue`
    case logout
}


extension BaseVC: NavigationSearchBarDelegate {

    @objc func navigationSearchBarTextChange(_ searchText: String?) {
    }

    @objc func navigationSearchBarBeginEditting() {}
    @objc func navigationSearchBarEndEditing() {}
    func navigationSearchBarEndEditingWithTextField(_ textField: UITextField) {}
    @objc func navigationSearchBarRemoved() {}
    func navigationSearchBarShouldReturn(_ searchBarTextField: UITextField) {
        searchBarTextField.resignFirstResponder()
    }

    final func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String, navigationSearchBar: NavigationSearchBar) -> Bool {

        if textField.text != nil {

            //emoji controll
            if textField.textInputMode?.primaryLanguage == "emoji" ||
                textField.textInputMode?.primaryLanguage == nil  {

                    return false
            }

            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            navigationSearchBarTextChange(text)
            return true
        }

        navigationSearchBarTextChange(nil)

        return true
    }

    final func textFieldShouldReturn(_ textField: UITextField, navigationSearchBar: NavigationSearchBar) -> Bool {
        navigationSearchBarShouldReturn(textField)
        return true
    }

    final func textFieldDidBeginEditing(_ textField: UITextField, navigationSearchBar: NavigationSearchBar) {
        //activeField = textField
        //textField.inputAccessoryView = keyboardCloseInputAccessoryView()
        navigationSearchBarBeginEditting()

    }

    final func textFieldDidEndEditing(_ textField: UITextField, navigationSearchBar: NavigationSearchBar) {
        navigationSearchBarEndEditing()
        navigationSearchBarEndEditingWithTextField(textField)
    }
}

