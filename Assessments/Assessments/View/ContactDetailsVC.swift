//
//  ContactDetailsVC.swift
//  testing2
//
//  Created by Kai Xuan on 16/01/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import UIKit

class ContactDetailsVC: UIViewController {
    
    @IBOutlet weak var imageView    : UIView!
    @IBOutlet weak var firstNameTF  : UITextField!
    @IBOutlet weak var lastNameTF   : UITextField!
    @IBOutlet weak var emailTF      : UITextField!
    @IBOutlet weak var phoneTF      : UITextField!
    var keyBoardNeedLayout          : Bool = true
    
    let cancelButtonText    = "Cancel"
    let saveButtonText      = "Save"
    
    var contactDetails:Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        setupDissmissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    func setupNavBar() {
        let leftButton                              = UIBarButtonItem(title: cancelButtonText,  style: .plain, target: self, action:#selector(cancelButtonTapped))
        let rightButton                             = UIBarButtonItem(title: saveButtonText,  style: .plain, target: self, action:#selector(saveButtonTapped))
        leftButton.tintColor                        = hexStringToUIColor(hex: appConstant.themeColor)
        rightButton.tintColor                       = hexStringToUIColor(hex: appConstant.themeColor)
        self.navigationItem.leftBarButtonItem       = leftButton
        self.navigationItem.rightBarButtonItem      = rightButton
    }
    
    func setupView() {
        self.imageView.layer.cornerRadius   = self.imageView.bounds.size.height / 2
        self.imageView.backgroundColor      = hexStringToUIColor(hex: appConstant.themeColor)
        
        self.firstNameTF.delegate   = self
        self.lastNameTF.delegate    = self
        self.emailTF.delegate       = self
        self.phoneTF.delegate       = self
        
        //Binding is not use in this case because auto update is not allow and user have to press save button to save.
        if contactDetails != nil {
            self.firstNameTF.text   = contactDetails?.firstName
            self.lastNameTF.text    = contactDetails?.lastName
            self.emailTF.text       = contactDetails?.email
            self.phoneTF.text       = contactDetails?.phone
        } else {
            // if contactDetails = nil, create new model
            contactDetails = Contact(id: nil, firstName: "", lastName: "", email: nil, phone: nil)
        }
    }

}

extension ContactDetailsVC: UITextFieldDelegate {
    
    // Easiest way to achieve pressing next to next text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          textField.resignFirstResponder()
       }
       return false
    }
    
}

extension ContactDetailsVC {
    
    func setupDissmissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(dismissKeyBoard(tapGestureRecognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyBoard(tapGestureRecognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    //Avoid Keyboards Block View
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(ContactDetailsVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactDetailsVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo         = notification.userInfo,
            let value           = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let _               = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let _               = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame           = value.cgRectValue
            let intersection    = frame.intersection(self.view.frame)
            
            let deltaY          = intersection.height - 250
            if keyBoardNeedLayout {
                UIView.animate(withDuration: 2.0, delay: 0.0,
                               options: ([.curveLinear]),
                               animations: {() -> Void in
                                self.view.frame = CGRect(x: 0,y: -deltaY,width: self.view.bounds.width,height: self.view.bounds.height)
                                self.keyBoardNeedLayout = false
                                self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let userInfo         = notification.userInfo,
            let value           = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let _               = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let _               = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            let frame           = value.cgRectValue
            let intersection    = frame.intersection(self.view.frame)
            let deltaY          = intersection.height
            UIView.animate(withDuration: 2.0, delay: 0.0,
                           options: ([.curveLinear]),
                           animations: {() -> Void in
                            self.view.frame = CGRect(x: 0,y: deltaY,width: self.view.bounds.width,height: self.view.bounds.height)
                            self.keyBoardNeedLayout = true
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

extension ContactDetailsVC {
    //Navigation Button Function
    
    @objc func cancelButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonTapped(){
        
        // Simple validation
        guard let firstName = self.firstNameTF.text, !firstName.isEmpty else{
            let alert = UIAlertController(title: "Alert", message: "First Name Cannot Be Empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        guard let lastName = self.lastNameTF.text, !lastName.isEmpty else{
            let alert = UIAlertController(title: "Alert", message: "Last Name Cannot Be Empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if self.emailTF.text!.count > 0 {
            let validateEmail = self.validateEmail(enteredEmail: self.emailTF.text!)
            
            if !validateEmail{
                let alert = UIAlertController(title: "Alert", message: "Email Format Wrong.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
        }
        
        if self.phoneTF.text!.count > 0 {
            let validatePhone = self.validatePhone(enteredPhone: self.phoneTF.text!)
            
            if !validatePhone{
                let alert = UIAlertController(title: "Alert", message: "Phone Should Not Contain Alphabet Or Special Characters.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
        }
        
        self.contactDetails?.firstName  = self.firstNameTF.text!
        self.contactDetails?.lastName   = self.lastNameTF.text!
        self.contactDetails?.email      = self.emailTF.text ?? nil
        self.contactDetails?.phone      = self.phoneTF.text ?? nil
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateEmail(enteredEmail:String) -> Bool {

        var returnValue = true
        let emailFormat = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailFormat)
            let nsString = enteredEmail as NSString
            let results = regex.matches(in: enteredEmail, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch _ as NSError {
            returnValue = false
        }
        
        return  returnValue
        
    }
    
    func validatePhone(enteredPhone: String) -> Bool {
        var returnValue = true
        let phoneFormat = #"[A-Za-z!@#$%^&*,.?":{}[\]|\/<>~=_]"# //Regex detects letters
        
        do {
            let regex = try NSRegularExpression(pattern: phoneFormat)
            let nsString = enteredPhone as NSString
            let results = regex.matches(in: enteredPhone, range: NSRange(location: 0, length: nsString.length))

            if results.count != 0
            {
                returnValue = false
            }
            
        } catch _ as NSError {
            returnValue = false
        }
        
        return  returnValue
    }
    
}
