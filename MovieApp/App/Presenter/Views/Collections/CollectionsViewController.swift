//
//  CollectionsViewController.swift
//  MovieApp
//
//  Created by Ishipo on 18/06/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class CollectionsViewController: UIViewController {
    @IBOutlet private weak var npCollectionView: UICollectionView!
    @IBOutlet private weak var upCollectionView: UICollectionView!
    @IBOutlet private weak var popularCollectionView: UICollectionView!
    @IBOutlet private weak var toprateCollectionView: UICollectionView!
    
    private var npData = [Movies]()
    private var upData = [Movies]()
    private var poData = [Movies]()
    private var topData = [Movies]()
    private var viewModel = CollectionsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.getNowPlaying()
        viewModel.getPopular()
        viewModel.getTopRate()
        viewModel.getUpComing()
        
        setupConfig()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    private func setupConfig() {
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width - 30 , height: view.bounds.width))
        titleLbl.textColor = .white
        titleLbl.text = "Collections"
        titleLbl.font = UIFont(name: "Hiragino Sans W6", size: 23)
        navigationItem.titleView = titleLbl
        
        npCollectionView.delegate = self
        upCollectionView.delegate = self
        popularCollectionView.delegate = self
        toprateCollectionView.delegate = self
        
        npCollectionView.dataSource = self
        upCollectionView.dataSource = self
        popularCollectionView.dataSource = self
        toprateCollectionView.dataSource = self
        
        npCollectionView.register(UINib(nibName: "NowPlayingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NowPlayingCollectionViewCell")
        upCollectionView.register(UINib(nibName: "UpComingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UpComingCollectionViewCell")
        popularCollectionView.register(UINib(nibName: "UpComingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UpComingCollectionViewCell")
        toprateCollectionView.register(UINib(nibName: "UpComingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UpComingCollectionViewCell")
        
    }
    
}

extension CollectionsViewController: UICollectionViewDelegateFlowLayout , UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == npCollectionView {
            let npCell = npCollectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingCollectionViewCell", for: indexPath) as! NowPlayingCollectionViewCell
            npCell.data = npData[indexPath.row]
            return npCell
            
        }else if collectionView == upCollectionView {
            let upCell = upCollectionView.dequeueReusableCell(withReuseIdentifier: "UpComingCollectionViewCell", for: indexPath) as! UpComingCollectionViewCell
            upCell.data = upData[indexPath.row]
            return upCell
            
        }else if collectionView == popularCollectionView {
            let poCell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: "UpComingCollectionViewCell", for: indexPath) as! UpComingCollectionViewCell
            poCell.data = poData[indexPath.row]
            return poCell
        }else {
            let rateCell = toprateCollectionView.dequeueReusableCell(withReuseIdentifier: "UpComingCollectionViewCell", for: indexPath) as! UpComingCollectionViewCell
            rateCell.data = topData[indexPath.row]
            return rateCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == npCollectionView {
            return npData.count
        }else if collectionView == upCollectionView {
            return upData.count
        }else if collectionView == popularCollectionView {
            return poData.count
        }else {
            return topData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.height
        
        if collectionView == npCollectionView {
            return CGSize(width: size/1.7, height: size)
        }else{
            return CGSize(width: size * 1.2, height: size)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == npCollectionView {
            
            let vc = InfoFilmViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: {
                vc.dataF = self.npData[indexPath.row]
            })
            
        }else if collectionView == upCollectionView {
            
            let vc = InfoFilmViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: {
                vc.dataF = self.upData[indexPath.row]
            })
            
        }else if collectionView == popularCollectionView {
            
            let vc = InfoFilmViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: {
                vc.dataF = self.poData[indexPath.row]
            })
        }else {
            let vc = InfoFilmViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: {
                vc.dataF = self.topData[indexPath.row]
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension CollectionsViewController : CollectionsViewModelDelegate {
    func showLoading() {
        LoadingView.shared.showProgressHubOnMainThread()
    }
    
    func hideLoading() {
        LoadingView.shared.dismissProgressHubOnMainThread()
    }
    
    func updateNowPlaying(_ movie: [Movies]) {
        npData = movie
        DispatchQueue.main.async {
            self.npCollectionView.reloadData()
        }
    }
    
    func updateUpComing(_ movie: [Movies]) {
        upData = movie
        DispatchQueue.main.async {
            self.upCollectionView.reloadData()
        }
    }
    
    func updatePopular(_ movie: [Movies]) {
        poData = movie
        DispatchQueue.main.async {
            self.popularCollectionView.reloadData()
        }
    }
    
    func updateTopRated(_ movie: [Movies]) {
        topData = movie
        DispatchQueue.main.async {
            self.toprateCollectionView.reloadData()
        }
    }
    
}
