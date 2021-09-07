//
//  FindFriendViewController.swift
//  MovieApp
//
//  Created by Ishipo on 05/07/2021.
//

import UIKit

class FindFriendViewController: UIViewController {
    private let tableView : UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.tableFooterView = UIView()
        tb.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        tb.register(UINib(nibName: "FollowingTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowingTableViewCell")
        return tb
    }()
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Interesting People"
        label.font = UIFont(name: "Hiragino Sans W6", size: 20)
        label.textColor = .white
        
        return label
    }()
    
    private var viewModel = UserViewModel()
    private var data = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupConfig()
    }
    
    
    func reloadData() {
        viewModel.fetchAllUser()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAllUser()
    }
    
    private func setupConfig() {
        view.backgroundColor = .clear
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
    }
}

extension FindFriendViewController : UITableViewDelegate , UITableViewDataSource {
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

extension FindFriendViewController : UserViewModelDelegate {
    func dataUserFollowing(_ user: [Users]) {
    }
    func dataUserFollower(_ user: [Users]) {
    }
    func dataAllUser(_ user: [Users]) {
        data = user
        tableView.reloadData()
    }
}
