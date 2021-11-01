//
//  CategoryDetailViewController.swift
//  MovieApp
//
//  Created by Ishipo on 26/09/2021.
//

import UIKit

class CategoryDetailViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = [Movies]()
    let viewModel = CategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "DiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiscoverCollectionViewCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension CategoryDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! DiscoverCollectionViewCell
        cell.updateUI(data[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width) / 3.1
        return CGSize(width: width, height: width * 1.5)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = InfoFilmViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: {
            vc.getMovieDetail(self.data[indexPath.row])
        })
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
extension CategoryDetailViewController : CategoryViewModelDelegate {
    func updateDataCategory(_ movie: [Movies]) {
        data = movie
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
    func showLoading() {
        LoadingView.shared.showProgressHubOnMainThread()
    }
    
    func hideLoading() {
        LoadingView.shared.dismissProgressHubOnMainThread()
    }
    
    
}
