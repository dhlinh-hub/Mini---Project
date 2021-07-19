//
//  FollowingViewController.swift
//  MovieApp
//
//  Created by Ishipo on 05/07/2021.
//

import UIKit

class FollowingViewController: UIViewController {
  var data = [Users]()
  var viewModel = UserViewModel()
  
  let tableView : UITableView = {
    let tb = UITableView()
    tb.translatesAutoresizingMaskIntoConstraints = false
    tb.tableFooterView = UIView()
    tb.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
    tb.register(UINib(nibName: "FollowingTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowingTableViewCell")
    return tb
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    viewModel.fetchUserFollowing()
    setupConfig()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.fetchUserFollowing()

  }
  
  func reloadData() {

    
    
  }
  
  private func setupConfig() {
    view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      
      
    ])
    
  }
  
}
extension FollowingViewController : UITableViewDelegate , UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingTableViewCell", for: indexPath) as! FollowingTableViewCell
    cell.data = data[indexPath.row]
    cell.onFollowCallBack = {
      self.viewModel.onFollow(self.data[indexPath.row])
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = InfoUserViewController()
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: false, completion: {
      vc.user = self.data[indexPath.row]
    })
  }
}
extension FollowingViewController : UserViewModelDelegate {
  func dataAllUser(_ user: [Users]) {
    
  }
  
  func dataUserFollowing(_ user: [Users]) {
    data = user
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  func dataUserFollower(_ user: [Users]) {
    
  }
  
  
}
