//
//  InfoUserViewController.swift
//  MovieApp
//
//  Created by Ishipo on 05/07/2021.
//

import UIKit
import Kingfisher

class InfoUserViewController: UIViewController {
  @IBOutlet weak var imageUser: UIImageView!
  @IBOutlet weak var nameUser: UILabel!
  @IBOutlet weak var emailUser: UILabel!
  @IBOutlet weak var followingButton: UIButton!
  @IBOutlet weak var followerButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var followButton: UIButton!
  
  var user : Users! {
    didSet{
      if let dataUser = user {
        self.viewModel.fetchLisFavorite(dataUser)
        self.viewModel.fetchCountFollowingUser(dataUser)
        self.viewModel.fetchCountFollowerUser(dataUser, completion: { state in
          if state {
            
            self.followerButton.setTitle("Follower \(self.follower ?? 0)", for: .normal)

          }else{
            self.followerButton.setTitle("Follower 0", for: .normal)
          }
          
        })

        
        nameUser.text = "\(dataUser.name!)"
        emailUser.text = "\(dataUser.email!)"
        if dataUser.currentFollowing == true {
          self.configFollowButton()
        }else {
          self.configUnFollowButton()
        }
        
        if let image = dataUser.image {
          let url = URL(string: image)
          imageUser.kf.setImage(with: url, placeholder: UIImage(named: "default"))
        }
        
      }
    }
  }
  var data = [Movies]()
  var viewModel = InfoUserViewModel()
  var viewModelFL = UserViewModel()
  let vc = FindFriendViewController()
  var follower : Int?
  var following : Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    viewModelFL.delegate = self
    setupConfig()
    
  }
  
  private func setupConfig() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(UINib(nibName: "DiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiscoverCollectionViewCell")
    imageUser.layer.cornerRadius = 50
    followingButton.layer.cornerRadius = 10
    followerButton.layer.cornerRadius = 10
    followButton.layer.cornerRadius = 10
  }
  func configFollowButton() {
    followButton.setTitle("Following", for: .normal)
    followButton.setTitleColor(.white, for: .normal)
    followButton.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
    followButton.layer.borderWidth = 0.5
    followButton.layer.borderColor = UIColor.white.cgColor
  }
  func configUnFollowButton() {
    followButton.setTitle("+ Follow", for: .normal)
    followButton.setTitleColor(.black, for: .normal)
    followButton.backgroundColor = .white
    followButton.layer.borderWidth = 0.5
    
  }
  
  @IBAction func onBackButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    
  }
  @IBAction func onFollowButton(_ sender: Any) {
    viewModelFL.onFollow(user)
    if user.currentFollowing == false {
      configUnFollowButton()
      
    }else {
      configFollowButton()
      }
  }
  
}

extension InfoUserViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource , UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! DiscoverCollectionViewCell
    cell.data = data[indexPath.row]
    cell.layer.cornerRadius = 10
    cell.layer.borderWidth = 0.2
    cell.layer.borderColor = UIColor.clear.cgColor
    
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.bounds.width) / 2.05
    return CGSize(width: width, height: width * 1.5)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 5
    
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = InfoFilmViewController()
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: false, completion: {
      vc.dataF = self.data[indexPath.row]
    })
  }
  
}

extension InfoUserViewController : InfoUserViewModelDelegate {
  func updateCountFollowing(_ index: Int) {
    following = index
  }
  
  func updateCountFollower(_ index: Int) {
    follower = index
    
  }
  
  func showLoading() {
    LoadingView.shared.showProgressHubOnMainThread()
  }
  
  func hideLoading() {
    LoadingView.shared.dismissProgressHubOnMainThread()
  }
  
  func updateListFavorite(_ movie: [Movies]) {
    data = movie
    self.collectionView.reloadData()
    
  }
  
  
}

extension InfoUserViewController : UserViewModelDelegate {
  func dataAllUser(_ user: [Users]) {
    
  }
  
  func dataUserFollowing(_ user: [Users]) {
    
  }
  
  func dataUserFollower(_ user: [Users]) {
    
  }
  
  
  
}
