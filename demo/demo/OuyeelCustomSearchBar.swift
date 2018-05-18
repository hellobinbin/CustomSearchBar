//
//  OuyeelCustomSearchBar.swift
//  TradingHelper
//
//  Created by nzb on 2018/3/15.
//  Copyright © 2018年 Ouyeel. All rights reserved.
//

import UIKit
/* 搜索图标的2种状态
 */
public enum OuyeelCustomSearchBarIconAlignment: UInt {
    case left
    case center
}
/* 代理方法  和searchbar 代理方法相同
 */
@objc protocol OuyeelCustomSearchBarDelegate: class {
    
   @objc optional func searchBarShouldBeginEditing(_ searchBar: OuyeelCustomSearchBar) -> Bool // return NO to not become first responder
    
   @objc optional func searchBarTextDidBeginEditing(_ searchBar: OuyeelCustomSearchBar) // called when text starts editing
    
   @objc optional func searchBarShouldEndEditing(_ searchBar: OuyeelCustomSearchBar) -> Bool // return NO to not resign first responder
    
   @objc optional func searchBarTextDidEndEditing(_ searchBar: OuyeelCustomSearchBar) // called when text ends editing
    
   @objc optional func searchBar(_ searchBar: OuyeelCustomSearchBar, textDidChange searchText: String) // called when text changes (including clear)
    
   @objc optional func searchBar(_ searchBar: OuyeelCustomSearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool // called before text changes
    
   @objc optional func searchBarSearchButtonClicked(_ searchBar: OuyeelCustomSearchBar) // called when keyboard search button pressed
    
   @objc optional func searchBarCancelButtonClicked(_ searchBar: OuyeelCustomSearchBar) // called when cancel button pressed
}

class OuyeelCustomSearchBar: UIView, UITextInputTraits{
    weak open var delegate: OuyeelCustomSearchBarDelegate?
    
    public var isHiddenCancelButton: Bool = false
    fileprivate var iconImgV: UIImageView?
    fileprivate var iconCenterImgV: UIImageView?
    fileprivate var iconAlignTemp: OuyeelCustomSearchBarIconAlignment?
    
    
    
    public var text: String? {
        set {
            textField.text = newValue
        }
        get {
            return textField.text
        }
    }
    public var textColor: UIColor! {
        willSet {
            textField.textColor = newValue
        }
    }
    public var textFont: UIFont! {
        willSet {
            textField.font = newValue
        }
    }
    public var prompt: String!
    public var placeholder: String! {
        willSet {
            textField.placeholder = newValue
            textField.contentMode = .scaleAspectFit
        }
    }
    
    public var iconAlignment: OuyeelCustomSearchBarIconAlignment! {
        willSet {
            iconAlignTemp = newValue
        }
        
        didSet {
            adjustIconWith(iconAlignment!)
        }
    }
    public var placeholderColor: UIColor! {
        willSet {
            if (placeholder == nil || placeholder == "") {
            } else {
                textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: newValue, NSAttributedStringKey.font: textField.font!])
            }
        }
    }
    public var textFieldColor: UIColor! {
        willSet {
            textField.backgroundColor = newValue
        }
    }
    
    public var _inputAccessoryView: UIView? {
        willSet {
            textField.inputAccessoryView = newValue
        }
    }
    
    public var _inputView: UIView? {
        willSet {
            textField.inputView = newValue
        }
    }
    
    public var iconImage: UIImage? {
        willSet {
            if (textField.leftView != nil) {
                (textField.leftView as! UIImageView).image = newValue
                textField.leftViewMode = .always
            }
        }
    }
    public var backgroundImage: UIImage? {
        willSet {
            textField.background = newValue
        }
    }
   @nonobjc func isFirstResponder() -> Bool {
        return textField.isFirstResponder
    }
    @nonobjc override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    @nonobjc override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        initView()
        sizeToFit()
    }
    
    open override func layoutSubviews() {
//        layoutSubviews()
        sizeToFit()
    }
    
    open override var intrinsicContentSize: CGSize {
        get {
            return UILayoutFittingExpandedSize
        }
    }
   
    
    private func initView() {
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 44);
        if isHiddenCancelButton == false {
            addSubview(cancelButton)
            cancelButton.isHidden = true
        }
        iconAlignTemp = .center
  
        addSubview(textField)
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: NSKeyValueObservingOptions.RawValue(UInt8(NSKeyValueObservingOptions.new.rawValue) | UInt8(NSKeyValueObservingOptions.old.rawValue))), context: nil)
    }
    // 取消按钮
    lazy var cancelButton: UIButton = {
        var cancelButton = UIButton(type: .custom)
        cancelButton.frame = CGRect(x: self.frame.size.width-60, y: 7, width: 60, height: 30)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.autoresizingMask = .flexibleLeftMargin
        cancelButton.addTarget(self, action: #selector(cancelButtonTouched), for: .touchUpInside)
        return cancelButton
    }()

    @objc func cancelButtonTouched() {
        textField.text = ""
        textField.resignFirstResponder()
        delegate?.searchBarCancelButtonClicked!(self)
    }
    // textField 属性
     lazy var textField: UITextField = {
        var textField = UITextField.init(frame: CGRect(x: 7, y: 7, width: self.frame.size.width-7*2, height: 30))
        
        textField.delegate = self
        textField.borderStyle = .none
        textField.contentVerticalAlignment = .center
        textField.returnKeyType = .search
        textField.enablesReturnKeyAutomatically = true
        textField.font = UIFont.systemFont(ofSize: 14.0)
        textField.clearButtonMode = .whileEditing
        
        textField.autoresizingMask = .flexibleWidth
        textField.borderStyle = .none;
        textField.layer.cornerRadius = 3.0;
        textField.layer.masksToBounds = true;
        textField.backgroundColor = UIColor(red: 240.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    @objc func textFieldDidChange(_ textField: UITextField!) {
        delegate?.searchBar!(self, textDidChange: textField.text!)
    }
    
    
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "frame"){
            adjustIconWith(iconAlignTemp!)
        }
    }
    
    // 图标的适应
    func adjustIconWith(_ iconAlignment: OuyeelCustomSearchBarIconAlignment) {
        if (iconAlignment == OuyeelCustomSearchBarIconAlignment.center && ((self.text == nil) || text?.count == 0) && !textField.isFirstResponder) {
            iconCenterImgV?.isHidden = false
            textField.frame = CGRect(x: 7, y: 7, width: frame.size.width - 7*2, height: 30)
            textField.textAlignment = .center
            
            let pString: String = placeholder ?? ""
            let titleSize = pString.size(withAttributes: [NSAttributedStringKey.font: textField.font! ])
            let x = textField.frame.size.width * 0.5 - titleSize.width * 0.5 - 30
            
            if iconCenterImgV == nil {
                iconCenterImgV = UIImageView(image: #imageLiteral(resourceName: "searchIcon"))
                iconCenterImgV?.contentMode = .scaleAspectFit
                textField.addSubview(iconCenterImgV!)
            }
  
            let xx: CGFloat = x>0 ? x : 0
            iconCenterImgV!.frame = CGRect(x: xx, y: 0, width: iconCenterImgV!.frame.size.width, height: iconCenterImgV!.frame.size.height)
            iconCenterImgV!.isHidden = x>0 ? false : true
            textField.leftView = x>0 ? nil : iconImgV
            textField.leftViewMode = x > 0 ? .never : .always
        } else {
            iconCenterImgV?.isHidden = true
            UIView.animate(withDuration: 1, animations: {
                self.textField.textAlignment = .left
                self.iconImgV = UIImageView(image: #imageLiteral(resourceName: "searchIcon"))
                self.iconImgV?.contentMode = .scaleAspectFit;
                self.textField.leftView = self.iconImgV;
                self.textField.leftViewMode =  .always;
            })
        }
    }
}
// textField 代理方法
extension OuyeelCustomSearchBar: UITextFieldDelegate{

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if iconAlignTemp == OuyeelCustomSearchBarIconAlignment.center {
            iconAlignment = OuyeelCustomSearchBarIconAlignment.left
        }
        if self.isHiddenCancelButton == false {
            UIView.animate(withDuration: 0.1, animations: {
                self.cancelButton.isHidden = false
                textField.frame = CGRect(x: 7, y: 7, width: self.cancelButton.frame.origin.x - 7, height: 30)
                
            })
        }
        
        _ = delegate?.searchBarShouldBeginEditing?(self)
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchBarTextDidBeginEditing?(self)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        _ =  delegate?.searchBarShouldEndEditing?(self)
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if iconAlignTemp == OuyeelCustomSearchBarIconAlignment.left {
            self.iconAlignment = .center
        }
        if self.isHiddenCancelButton == false {
            UIView.animate(withDuration: 0.1, animations: {
                self.cancelButton.isHidden = true
                textField.frame = CGRect(x: 7, y: 7, width: self.frame.size.width - 7*2, height: 30)
            })
        }
        delegate?.searchBarTextDidEndEditing?(self)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        _ = delegate?.searchBar?(self, shouldChangeTextIn: range, replacementText: string)
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.searchBar?(self, textDidChange: "")
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.searchBarSearchButtonClicked?(self)
        return true
    }
}
