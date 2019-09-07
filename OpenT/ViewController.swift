//
//  ViewController.swift
//  OpenT
//
//  Created by MAC on 04/09/2019.
//  Copyright © 2019 EdJordan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nickOne: UITextField!
    @IBOutlet weak var nickTwo: UITextField!
    
    @IBAction func startButton(_ sender: Any) {
        
        if nickOne.text!.isEmpty || nickTwo.text!.isEmpty{
            let alert = UIAlertController(title: "Atención", message: "Debe rellenar todos los apodos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let myVC = storyBoard.instantiateViewController(withIdentifier: "GameVC") as! GameVC
            myVC.apodoUno = nickOne.text!
            myVC.apodoDos = nickTwo.text!
            self.present(myVC, animated:true, completion:nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        
        nickOne.placeholder = "Escribe un apodo aquí"
        nickTwo.placeholder = "Escribe un apodo aquí"
        
        nickOne.delegate = self
        nickTwo.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 60 //keyboardSize.height   //can adjust as keyboardSize.height-(any number 30 or 40)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nickOne.resignFirstResponder()
        nickTwo.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardChangeFrameObserver(willShow: { [weak self](height) in
            //Update constraints here
            self?.view.setNeedsUpdateConstraints()
            }, willHide: { [weak self](height) in
                //Reset constraints here
                self?.view.setNeedsUpdateConstraints()
        })
    }
    
    
    
    
    
    
    
    
}

extension UIViewController {
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
//MARK: - Observers
extension UIViewController {
    
    func addObserverForNotification(_ notificationName: Notification.Name, actionBlock: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: OperationQueue.main, using: actionBlock)
    }
    
    func removeObserver(_ observer: AnyObject, notificationName: Notification.Name) {
        NotificationCenter.default.removeObserver(observer, name: notificationName, object: nil)
    }
}




//MARK: - Keyboard handling
extension UIViewController {
    
    typealias KeyboardHeightClosure = (CGFloat) -> ()
    
    func addKeyboardChangeFrameObserver(willShow willShowClosure: KeyboardHeightClosure?,
                                        willHide willHideClosure: KeyboardHeightClosure?) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil, queue: OperationQueue.main, using: { [weak self](notification) in
                                                if let userInfo = notification.userInfo,
                                                    let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                                                    let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
                                                    let c = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
                                                    let kFrame = self?.view.convert(frame, from: nil),
                                                    let kBounds = self?.view.bounds {
                                                    
                                                    let animationType = UIView.AnimationOptions(rawValue: c)
                                                    let kHeight = kFrame.size.height
                                                    UIView.animate(withDuration: duration, delay: 0, options: animationType, animations: {
                                                        if kBounds.intersects(kFrame) { // keyboard will be shown
                                                            willShowClosure?(kHeight)
                                                        } else { // keyboard will be hidden
                                                            willHideClosure?(kHeight)
                                                        }
                                                    }, completion: nil)
                                                } else {
                                                    print("-->Invalid conditions for UIKeyboardWillChangeFrameNotification")
                                                }
        })
    }
    
    func removeKeyboardObserver() {
        removeObserver(self, notificationName: UIResponder.keyboardWillChangeFrameNotification)
    }
}
