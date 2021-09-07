//
//  CreditsViewController.swift
//  MovieApp
//
//  Created by Ishipo on 28/06/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreditsViewController: UIViewController {
    
    @IBOutlet private weak var nillLabel: UILabel!
    @IBOutlet private weak var castLabel: UILabel!
    @IBOutlet private weak var countMovieLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    var cast : Cast? {
        didSet {
            if let data = cast {
                castLabel.text = "\(data.name!)"
                self.viewModel.getList(data)
            }
        }
    }
    private var data  = [Movies]()
    private var viewModel = CreditViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource  = self
        collectionView.register(UINib(nibName: "CreditsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CreditsCollectionViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction private func onClose(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
extension CreditsViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreditsCollectionViewCell", for: indexPath) as! CreditsCollectionViewCell
        cell.data = data[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width
        
        return CGSize(width: size / 2.05 , height: size / 1.1)
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

extension CreditsViewController : CreditViewModelDelegate {
    func updateInfoCast(_ movie: [Movies]) {
        data = movie
        collectionView.reloadData()
    }
    
    func updateCountMovie(_ count: Int) {
        countMovieLabel.text = "\(count) Movies"
        
    }
    func showLoading() {
        LoadingView.shared.showProgressHubOnMainThread()
    }
    
    func hideLoading() {
        LoadingView.shared.dismissProgressHubOnMainThread()
    }
    
    
}
