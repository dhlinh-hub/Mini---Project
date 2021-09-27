//
//  SeachViewController.swift
//  MovieApp
//
//  Created by Ishipo on 21/06/2021.
//

import UIKit

class SeachViewController: UIViewController {
  
    private  let tableView : UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.register(UINib(nibName: "SeachTableViewCell", bundle: nil), forCellReuseIdentifier: "SeachTableViewCell")
        view.backgroundColor = .init(hex: "#161616")
        view.tableFooterView = UIView()
        view.separatorStyle = .none
        view.separatorColor = .clear
        return view
    }()
    
    private var viewModels = SeachViewModels()
    private var data = [Movies]()
    
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
    }
    private func setupConfig() {
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .black
       
        let seachbar = UISearchBar()
        seachbar.sizeToFit()
        seachbar.placeholder = "Search Movies"
        seachbar.delegate = self
        navigationItem.titleView = seachbar
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
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
        cell.updateUI(data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.bounds.height / 7
        return height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = InfoFilmViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: {
            vc.data = self.data[indexPath.row]
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
            viewModels.updateData(searchText.removeAllWhitespaces())
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
