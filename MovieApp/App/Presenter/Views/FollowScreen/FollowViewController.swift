//
//  FollowViewController.swift
//  MovieApp
//
//  Created by Ishipo on 04/07/2021.
//

import UIKit
import Duang


class FollowViewController: UIViewController {
    
    private var page = ["Following" , "Follower", "FindFriend"]
    private var viewModel = UserViewModel()
    private var data = [Users]()
    private  var seachData = [Users]()
    
    private lazy var pageMenu: Duang = {
        let menu = Duang(
            frame: CGRect(x: 0, y: 102, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100),
            subControllers: [FollowingViewController.self, FollowerViewController.self, FindFriendViewController.self],
            dataSource: self,
            delegate: self,
            controlBarHeight: 40,
            loadAllCtl: false,
            style: .full)
        menu.segmentBackgroundImage = UIImage(named: "nike")
        menu.controlSpacing = 10.0
        menu.segmentHeight = 5.0
        return menu
    }()
    
    let tableView : UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        view.register(UINib(nibName: "FollowingTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowingTableViewCell")
        view.tableFooterView = UIView()
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
        seachData = data
        
        setupConfig()
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func setupConfig() {
        
        view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        setupXmark()
        let seachbar = UISearchBar()
        seachbar.sizeToFit()
        seachbar.placeholder = "Search for Name"
        seachbar.delegate = self
        seachbar.tintColor = .white
        seachbar.searchTextField.textColor = .white
        seachbar.showsCancelButton = true
        navigationItem.titleView = seachbar
        
        view.addSubview(pageMenu)
        pageMenu.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0 ),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
        ])
    }
    private func setupXmark() {
        let xmark = UIButton(type: .custom)
        xmark.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        xmark.setImage(UIImage(named:"x"), for: .normal)
        xmark.addTarget(self, action: #selector(onXmark), for: .touchUpInside)
        
        let xmarkButton = UIBarButtonItem(customView: xmark)
        let currWidth = xmarkButton.customView?.widthAnchor.constraint(equalToConstant: 15)
        currWidth?.isActive = true
        let currHeight = xmarkButton.customView?.heightAnchor.constraint(equalToConstant: 15)
        currHeight?.isActive = true
        navigationItem.leftBarButtonItem = xmarkButton
    }
    
    @objc func onXmark() {
        self.dismiss(animated: false, completion: nil)
    }
}
extension FollowViewController: DuangDataSource {
    
    func duangControlBar(itemForIndex index: Int) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "\(page[index])"
        
        return label
    }
    
}


extension FollowViewController: DuangDelegate {
    func duang(initialized ctl: UIViewController) {
        print("[Duang] initialized:", ctl)
    }
    
    func duang(current ctl: UIViewController, page: Int) {
        print("[Duang] current ctl:]", ctl)
        switch page {
        case 0:
            if let currentVC = ctl as? FollowingViewController {
                currentVC.reloadData()
            }
        case 1 :
            if let currentFL = ctl as? FollowerViewController {
                currentFL.reloadData()
            }
        default:
            if let currentFL = ctl as? FindFriendViewController {
                currentFL.reloadData()
            }
        }
    }
    
    func duang(current item: UIView) {
        print("[Duang] current item", item)
    }
    
    func duang(didSelectControlBarAt index: Int) {
    }
}

extension FollowViewController : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.fetchAllUser()
        
        if searchText == "" {
            pageMenu.isHidden = false
            tableView.isHidden = true
        }else{
            pageMenu.isHidden = true
            tableView.isHidden = false
            seachData = data.filter({ _data  in
                return (_data.name?.contains(searchText))!
            })
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FollowViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seachData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingTableViewCell", for: indexPath) as! FollowingTableViewCell
        
        cell.data = seachData[indexPath.row]
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
            vc.user = self.seachData[indexPath.row]
        })
    }
}
extension FollowViewController : UserViewModelDelegate {
    func dataAllUser(_ user: [Users]) {
        data = user
        tableView.reloadData()
    }
    
    func dataUserFollowing(_ user: [Users]) {
    }
    
    func dataUserFollower(_ user: [Users]) {
    }
    
}
