//
//  SeachViewController.swift
//  MovieApp
//
//  Created by Ishipo on 21/06/2021.
//

import UIKit
import SwiftyJSON
import Alamofire

class SeachViewController: UIViewController {
    
    private var viewModels = SeachViewModels()
    private var data = [Movies]()
    private  let tableView : UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.register(UINib(nibName: "SeachTableViewCell", bundle: nil), forCellReuseIdentifier: "SeachTableViewCell")
        view.backgroundColor = .black
        view.tableFooterView = UIView()
        
        
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        viewModels.delegate = self
        
        setupConfig()
        setupXmark()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    private func setupConfig() {
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .black
        var topbarHeight: CGFloat {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
        
        let seachbar = UISearchBar()
        seachbar.sizeToFit()
        seachbar.placeholder = "Search Movies"
        seachbar.delegate = self
        navigationItem.titleView = seachbar
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: topbarHeight),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
        
    }
    
    private func setupXmark() {
        let xmark = UIButton(type: .custom)
        xmark.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        xmark.setImage(UIImage(named:"x"), for: .normal)
        xmark.addTarget(self, action: #selector(onXmark), for: .touchUpInside)
        
        let xmarkButton = UIBarButtonItem(customView: xmark)
        let currWidth = xmarkButton.customView?.widthAnchor.constraint(equalToConstant: 15)
        currWidth?.isActive = true
        let currHeight = xmarkButton.customView?.heightAnchor.constraint(equalToConstant: 15)
        currHeight?.isActive = true
        navigationItem.rightBarButtonItem = xmarkButton
    }
    
    
    
    
    @objc private func onXmark() {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
}
extension SeachViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeachTableViewCell", for: indexPath) as! SeachTableViewCell
        
        cell.data = data[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.bounds.height / 8
        return height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = InfoFilmViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: {
            vc.dataF = self.data[indexPath.row]
        })
        
    }
}

extension SeachViewController : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            data.removeAll()
            tableView.reloadData()
        } else {
            viewModels.updateData(searchText)
        }
    }
}
extension SeachViewController : SeachViewModelsDelegate {
    
    func updateSeach(_ movies: [Movies]) {
        data = movies
        tableView.reloadData()
    }
    func showLoading() {
        LoadingView.shared.showProgressHubOnMainThread()
    }
    
    func hideLoading() {
        LoadingView.shared.dismissProgressHubOnMainThread()
    }
    
}
