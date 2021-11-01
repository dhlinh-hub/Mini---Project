//
//  SignInViewController.swift
//  MovieApp
//
//  Created by Ishipo on 18/06/2021.
//

import UIKit

class SIAccountViewController: UIViewController {
    
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var layerView: UIView!
    @IBOutlet private weak var eyeButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    let hidden = UIImage(systemName: "eye.slash.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray)
    let show = UIImage(systemName: "eye")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    private func setupUI() {
        layerView.setGradientView()
        layerView.layer.masksToBounds = true
        layerView.makeCorner(radius: 50, corners: [.topLeft])
        eyeButton.setImage(show, for: .normal)

        
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
    
    @IBAction func hiddenKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction private func pressEyeButton(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
       
        let secureTextImage = passwordTextField.isSecureTextEntry ? show : hidden
        eyeButton.setImage(secureTextImage, for: .normal)
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

