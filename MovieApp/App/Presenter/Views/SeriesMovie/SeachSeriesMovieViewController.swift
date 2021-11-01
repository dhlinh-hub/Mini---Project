//
//  SeachSeriesMovieViewController.swift
//  MovieApp
//
//  Created by Ishipo on 03/10/2021.
//

import UIKit

class SeachSeriesMovieViewController: UIViewController {
    @IBOutlet weak var seachBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = [SeriesMovie]()
    var viewModel = SeachSeriesMovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seachBar.delegate = self
        viewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SeriesCell", bundle: nil), forCellWithReuseIdentifier: "SeriesCell")

    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        seachBar.endEditing(true)
    }

}
extension SeachSeriesMovieViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeriesCell", for: indexPath) as! SeriesCell
        cell.updateUI(data[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc  = CategoryDetailViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: {
            vc.lblTitle.text = self.data[indexPath.row].name
            vc.viewModel.getSeriesDetail(self.data[indexPath.row])
        })
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension SeachSeriesMovieViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            data.removeAll()
            collectionView.reloadData()
        }else {
            viewModel.seachData(searchText.removeAllWhitespaces())
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension SeachSeriesMovieViewController : SeachSeriesMovieViewModelDelegate {
    func updateData(_ series: [SeriesMovie]) {
        data = series
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
  
}
