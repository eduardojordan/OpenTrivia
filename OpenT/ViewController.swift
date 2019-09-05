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
