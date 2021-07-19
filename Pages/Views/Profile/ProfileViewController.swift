//
//  ProfileViewController.swift
//  MovieApp
//
//  Created by Ishipo on 18/06/2021.
//

import UIKit
import Kingfisher
class ProfileViewController: UIViewController {
  
  @IBOutlet weak var imageUser: UIImageView!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var userLabel: UILabel!
  @IBOutlet weak var followingButton: UIButton!
  @IBOutlet weak var followerButton: UIButton!
  
  var data = ["Privacy & Policy", "Terms & Conditions","Change Password" ,"Sign Out" ]
  var viewModel = ProfileViewModel()
  var following : Int?
  var follower : Int?
  var userData : Users? {
    didSet{
      if let data = userData {
        userLabel.text = "\(data.name!)"
        emailLabel.text = "\(data.email!)"
        if let image = data.image {
          let url = URL(string: "\(image)")
          imageUser.kf.setImage(with: url, placeholder: UIImage(named: "default"))
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupConfig()
    viewModel.fetchUser()
    viewModel.fetchCountFollowerUser(completion: { state in
      if state {
        self.followerButton.setTitle("Follower \(self.follower ?? 0)", for: .normal)
      }else{
        self.followerButton.setTitle("Follower 0", for: .normal)
      }
    })
    viewModel.fetchCountFollowingUser(completion: { state in
      if state {
        self.followingButton.setTitle("Following \(self.following ?? 0)", for: .normal)
      }else {
        self.followingButton.setTitle("Following 0", for: .normal)

      }
    })
  }
  private func  setupConfig() {
    let titleLbl = UILabel(frame: CGRect (x: 0, y: 0, width: view.bounds.width - 30, height: view.bounds.height))
    titleLbl.textColor = .white
    titleLbl.text = "Profile"
    titleLbl.font = UIFont(name: "Hiragino Sans W6", size: 23)
    navigationItem.titleView = titleLbl
    
    
    imageUser.layer.cornerRadius = 50
    cameraButton.layer.cornerRadius = 15
    followingButton.layer.cornerRadius = 10
    followerButton.layer.cornerRadius = 10
    tableView.tableFooterView = UIView()
    tableView.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
    cameraButton.addTarget(self, action: #selector(onCamera), for: .touchUpInside)
    followingButton.addTarget(self, action: #selector(onFollow), for: .touchUpInside)
    followerButton.addTarget(self, action: #selector(onFollow), for: .touchUpInside)
    
  }
  @objc func onFollow() {
    gotoFollowCreen()
    
  }
 
  @objc func onCamera() {
    let arlet = UIAlertController(title: "Report", message: "Sellection To", preferredStyle: .alert)
    let camera = UIAlertAction(title: "Camera", style: .default, handler: { act in
      self.openCamera()
      print("succes")
    })
    let library = UIAlertAction(title: "Library", style: .default, handler: { act in
      self.openGallery()
    })
    let exit = UIAlertAction(title: "Exit", style: .cancel, handler: nil)
    
    arlet.addAction(camera)
    arlet.addAction(library)
    arlet.addAction(exit)
    self.present(arlet, animated: true, completion: nil)
  }
  
  private func gotoFollowCreen() {
    let vc = UINavigationController(rootViewController: FollowViewController())
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: false, completion: nil)
    
  }
  func onSignOut() {
    FireBaseManager.shared.logout(completion: { state in
      if state {
        self.viewModel.resetAlluser()
        self.goBackLoginScreen()
      }else {
        print("Logout Failure")
      }
    })
  }
  
}



extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
    cell.titleLabel.text = data[indexPath.row]
    
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let cell = tableView.cellForRow(at: indexPath) as! ProfileTableViewCell
    
    switch cell.titleLabel.text {
    case "Sign Out":
      self.onSignOut()
      
    case "Change Password" :
      self.gotoChangePassScreen()
      
    default:
      guard let url = URL(string: "https://www.facebook.com/pikapoo1/") else {return}
      UIApplication.shared.open(url)
    }
  }
  func goBackLoginScreen() {
    let loginVC = LoginViewController()
    if let window = UIApplication.shared.windows.first {
      window.rootViewController = loginVC
      window.makeKeyAndVisible()
    }
  }
  
  func gotoChangePassScreen() {
    let vc = ChangePasswordViewController()
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: false, completion: nil)
    
  }
  func openCamera(){
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = UIImagePickerController.SourceType.camera
      imagePicker.allowsEditing = true
      self.present(imagePicker, animated: true, completion: nil)
    }
  }
  func openGallery(){
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
      self.present(imagePicker, animated: true, completion: nil)
    }
    else{
      showAlert()
    }
  }
  func showAlert() {
    let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}

extension ProfileViewController :  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let pickedImage = info[.editedImage] as? UIImage {
      viewModel.uploadImage(image: pickedImage)
      picker.dismiss(animated: true, completion: nil)
      
    }
    
  }
  
}
extension ProfileViewController : ProfileViewModelDelegate {
  func showLoading() {
    LoadingView.shared.showProgressHubOnMainThread()
  }
  
  func hideLoading() {
    LoadingView.shared.dismissProgressHubOnMainThread()
  }
  
  func updateCountFollowing(_ index: Int) {
    following = index
    
  }
  
  func updateCountFollower(_ index: Int) {
    follower = index
    
  }
  
  func updateInfoUser(_ user: Users) {
    userData = user
    
  }
 
  
}
