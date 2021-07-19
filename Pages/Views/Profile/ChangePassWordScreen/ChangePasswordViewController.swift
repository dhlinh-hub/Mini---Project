//
//  ChangePasswordViewController.swift
//  MovieApp
//
//  Created by Ishipo on 23/06/2021.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {
  
  @IBOutlet weak var layerView: UIView!
  @IBOutlet weak var newPasswordLabel: UITextField!
  @IBOutlet weak var confirmLabel: UITextField!
  @IBOutlet weak var resetButton: UIButton!
  @IBOutlet weak var validatePasswordLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupConfig()
    
  }
  private func setupConfig() {
    newPasswordLabel.layer.borderWidth = 0.5
    newPasswordLabel.layer.cornerRadius = 10
    newPasswordLabel.layer.borderColor = UIColor.lightGray.cgColor

    confirmLabel.layer.borderWidth = 0.5
    confirmLabel.layer.cornerRadius = 10
    confirmLabel.layer.borderColor = UIColor.lightGray.cgColor

    layerView.layer.cornerRadius = 40
    layerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    resetButton.layer.cornerRadius = 10
    newPasswordLabel.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)) , for: .editingChanged)
  }
  
  @IBAction func onReset(_ sender: Any) {
    guard let new = newPasswordLabel.text else {return}
    guard let confirm = confirmLabel.text else {return}
    
    if new == confirm {
      Auth.auth().currentUser?.updatePassword(to: confirm) { (error) in
        if let error = error {
          print(error)
          
        }else {
          self.setupArlet()
        }
      }
      
    }else {
      self.alertChangePassWordFailure()
    }
  }
  
  @IBAction func onBack(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  private func alertChangePassWordFailure() {
    let alert = UIAlertController(title: "Failure", message: "Password does not match", preferredStyle: .alert)
    let no = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    
    alert.addAction(no)
    self.present(alert, animated: true, completion: nil)
  }
  
  
  private func setupArlet() {
    let alert = UIAlertController(title: "Change password successfully", message: "Do you want to get out?", preferredStyle: .alert)
    let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
    let yes = UIAlertAction(title: "Yes", style: .default, handler: { act in
      self.goBackLoginScreen()
    })
    
    alert.addAction(yes)
    alert.addAction(no)
    self.present(alert, animated: true, completion: nil)
  }
  
  func goBackLoginScreen() {
    let loginVC = LoginViewController()
    if let window = UIApplication.shared.windows.first {
      window.rootViewController = loginVC
      window.makeKeyAndVisible()
    }
  }
}

extension ChangePasswordViewController : UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    if isValidPass(passWord: newPasswordLabel.text!) {
         
          validatePasswordLabel.isHidden = true
          
      }else{
        validatePasswordLabel.isHidden = false
         
      }
  }
 
  func isValidPass(passWord : String) -> Bool {
      let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
      
      let passPred = NSPredicate(format: "SELF MATCHES %@", passRegEx)
      
      
      return passPred.evaluate(with: passWord)
  }
}
