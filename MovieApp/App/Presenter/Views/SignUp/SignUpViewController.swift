//
//  SignUpViewController.swift
//  MovieApp
//
//  Created by Ishipo on 18/06/2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet private weak var layerView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var validEmailLabel: UILabel!
    @IBOutlet private weak var validPasswordLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
    }
    
    private func setupConfig() {
        layerView.setGradientView()
        layerView.makeCorner(radius: 50, corners: [.topLeft])
        emailTextField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        
        
    }
    @IBAction private func onBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction private func onSignUp(_ sender: Any) {
        guard let email = emailTextField.text , let password = passwordTextField.text, let name = userNameTextField.text else {return}
        FireBaseManager.shared.register(email, password, name, completion: { state in
            if state {
                self.showAlertSucces()
                
            }else{
                self.showAlertFailure()
            }
        })
    }
    
    private func showAlertSucces() {
        let arlet = UIAlertController(title: "Account successfully created", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .default, handler: {(act) in
            self .dismiss(animated: true, completion: nil)
        })
        
        arlet.addAction(cancel)
        self.present(arlet, animated: true, completion: nil)
        
    }
    private func showAlertFailure() {
        let arlet = UIAlertController(title: "This email is already in use by someone else", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        arlet.addAction(cancel)
        self.present(arlet, animated: true, completion: nil)
    }
    
}
extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if isValidEmail(email: emailTextField.text!) {
            
            validEmailLabel.isHidden = true
        }else{
            validEmailLabel.isHidden = false
        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isValidPass(passWord: passwordTextField.text!) {
            validPasswordLabel.isHidden = true
        }else {
            validPasswordLabel.isHidden = false
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: email)
    }
    
    func isValidPass(passWord : String) -> Bool {
        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passPred = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        
        return passPred.evaluate(with: passWord)
    }
}
