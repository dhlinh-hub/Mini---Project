//
//  SignInViewController.swift
//  MovieApp
//
//  Created by Ishipo on 18/06/2021.
//

import UIKit

class SignInViewController: UIViewController {
    
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var layerView: UIView!
    @IBOutlet private weak var eyeButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    private var isState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConFig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    private func setupConFig() {
        emailTextField.layer.borderWidth = 0.5
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        layerView.layer.cornerRadius = 70
        layerView.layer.maskedCorners = .layerMinXMinYCorner
        signInButton.layer.cornerRadius = 25
    }
    
    private func setupAlert() {
        let arlet = UIAlertController(title: "Incorrect account password or Email is already in use by someone else", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        arlet.addAction(cancel)
        self.present(arlet, animated: true, completion: nil)
    }
    
    private func gotoMainViewConTroller () {
        let vc = MainTabbar.setupTabar()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction private func pressEyeButton(_ sender: Any) {
        if isState {
            eyeButton.setImage(UIImage(systemName: "eye.slash.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
            eyeButton.contentScaleFactor = 50
            passwordTextField.isSecureTextEntry = false
            
        }else {
            eyeButton.setImage(UIImage(systemName: "eye")?.withRenderingMode(.alwaysOriginal), for: .normal)
            eyeButton.scalesLargeContentImage = true
            
            passwordTextField.isSecureTextEntry = true
        }
        isState = !isState
    }
    
    @IBAction private func onSignIn(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {return }
        FireBaseManager.shared.login(email, password, completion: { state in
            if state {
                self.gotoMainViewConTroller()
            }
            self.setupAlert()
        })
    }
    
    private func gotoSignUpController() {
        let vc = SignUpViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction private func onSignUp(_ sender: Any) {
        self.gotoSignUpController()
    }
    @IBAction private func onBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
