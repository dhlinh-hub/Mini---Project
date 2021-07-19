//
//  FavoriteViewController.swift
//  MovieApp
//
//  Created by Ishipo on 21/06/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class FavoriteViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel = FavoriteViewModel()
  var data = [Movies]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupConfig()
    viewModel.delegate = self

    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    callAPI()

    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  
    
  }
  private func  setupConfig()  {
    
    let titleLbl = UILabel(frame: CGRect (x: 0, y: 0, width: view.bounds.width - 30, height: view.bounds.height))
    titleLbl.textColor = .white
    titleLbl.text = "Fovarite"
    titleLbl.font = UIFont(name: "Hiragino Sans W6", size: 23)
    navigationItem.titleView = titleLbl
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")
    tableView.tableFooterView = UIView()
  }
  
 public func callAPI(){
    viewModel.fetchUser(completion: { state in
      if state {

      }else {
        self.data.removeAll()
        self.tableView.reloadData()
        self.tabBarController?.tabBar.items?[2].badgeValue = nil

      }

    })
  }
  
  
}
extension FavoriteViewController : UITableViewDelegate , UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
    
    cell.data = data[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        let size = tableView.bounds.height / 3
    return 120
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc  = InfoFilmViewController()
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: false, completion: {
      vc.dataR = self.data[indexPath.row]
    })
  }
  
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let idMovie = self.data[indexPath.row].id

    let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, sourceView, completionHandler) in
      let arlet = UIAlertController(title: "Are you sure you want to delete?", message: "", preferredStyle: .alert)
      let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
      let yes = UIAlertAction(title: "Yes", style: .default, handler: { act in
        self.data.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("user").child(uid!)
        ref.child("List").child("\(idMovie!)").removeValue(completionBlock: { _ , _ in
         
          self.callAPI()

        })
        
      })
      arlet.addAction(no)
      arlet.addAction(yes)
      
      self.present(arlet, animated: true, completion: nil)
    })
    delete.backgroundColor = .red
    let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
    swipeActionConfig.performsFirstActionWithFullSwipe = false
    return swipeActionConfig
  }
}


extension FavoriteViewController : FavoriteViewModelDelegate {
  func updateBagdeValue(_ count: Int) {
    tabBarController?.tabBar.items?[2].badgeValue = "\(count)"
  }
  
  
  
  func updateFavorite(_ movie: [Movies]) {
    data = movie
    tableView.reloadData()
  }
  
  
}
