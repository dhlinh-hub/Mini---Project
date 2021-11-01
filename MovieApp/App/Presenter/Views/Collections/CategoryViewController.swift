//
//  CategoryViewController.swift
//  MovieApp
//
//  Created by Ishipo on 19/09/2021.
//

import UIKit

class CategoryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let collec = [
        Collections(image: "popular", discrip: "What Is The Most Popular These Days?", type: .popular),
        Collections(image: "nowplaying", discrip: "Trending Today", type: .now_playing),
        Collections(image: "upcoming", discrip: "Upcoming Movies", type: .upcoming),
        Collections(image: "toprated", discrip: "Top Rated Movies Today", type: .top_rated),
    ]
    
    let viewModel = CategoryViewModel()
    var data = [Movies]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func seriesMovieAction(_ sender: Any) {
        let vc = SeachSeriesMovieViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension CategoryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collec.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.setupUI(collec: collec[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = CategoryDetailViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: {
                vc.viewModel.getMovie(self.collec[indexPath.row].type)
                vc.lblTitle.text = self.collec[indexPath.row].discrip
            })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height/2.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
extension CategoryViewController : CategoryViewModelDelegate {
    func updateDataCategory(_ movie: [Movies]) {
        data = movie
    }
    func showLoading() {
        LoadingView.shared.showProgressHubOnMainThread()
    }
    func hideLoading() {
        LoadingView.shared.dismissProgressHubOnMainThread()
    }
    
    
}
