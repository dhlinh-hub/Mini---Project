//
//  DiscoverViewController.swift
//  MovieApp
//
//  Created by Ishipo on 18/06/2021.
//

import UIKit


class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    var data = [Movies]()
    var viewModels = DiscoverViewModel()
    var genres = [Genres]()
    var lastIndexActive:IndexPath = [1 ,0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModels.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModels.getMovies(1)
        viewModels.getAllGenre(.movie)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "DiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiscoverCollectionViewCell")
        ///
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
        genresCollectionView.register(UINib(nibName: "GenresCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenresCollectionViewCell")
        ///
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.addTarget(self, action: #selector(handleSegmenControl), for: .valueChanged)
        segmentControl.setTitleTextAttributes(titleTextAttributes, for:.normal)
        segmentControl.selectedSegmentTintColor = .init(hex:"#36D1DC")
        
    }
    
    
    @IBAction func seachAction(_ sender: Any) {
        let vc  = UINavigationController(rootViewController: SeachViewController())
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    private func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -collectionView.contentInset.top )
        self.collectionView.setContentOffset(desiredOffset, animated: true)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}
extension DiscoverViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genresCollectionView {
            return genres.count
        }else {
            return data.count - 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genresCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCollectionViewCell", for: indexPath) as! GenresCollectionViewCell
            cell.lblTitle.text = genres[indexPath.row].name
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! DiscoverCollectionViewCell
            cell.updateUI(data[indexPath.row])
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            let width = (collectionView.bounds.width) / 3.1
            return CGSize(width: width, height: width * 1.5)
        }else {
            return CGSize(width: 100 , height: 35)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView {
            let vc = InfoFilmViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: {
                vc.getMovieDetail(self.data[indexPath.row])
            })
            
        }else {
            if self.lastIndexActive != indexPath {
            let cell = collectionView.cellForItem(at: indexPath) as! GenresCollectionViewCell
                cell.lblTitle.textColor = .init(hex:"#36D1DC")
            
            let cell1 = collectionView.cellForItem(at: self.lastIndexActive) as? GenresCollectionViewCell
                cell1?.lblTitle.textColor = .white
                self.lastIndexActive = indexPath

            }
        }
    }
    

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.viewModels.scrollAppendData(self.segmentControl.selectedSegmentIndex)
        })
    }
    
    @objc private func handleSegmenControl() {
        viewModels.handleSegment(segmentControl.selectedSegmentIndex)
        scrollToTop()
    }
}

extension DiscoverViewController: DiscoverViewModelDelegate {
    func updateGenres(_ genres: [Genres]) {
        self.genres = genres
        genresCollectionView.reloadData()
    }
    
    func updateMovies(_ movies: [Movies]) {
        self.data = movies
        reloadData()
    }
    
    func showLoading() {
        LoadingView.shared.showProgressHubOnMainThread()
    }
    
    func hideLoading() {
        LoadingView.shared.dismissProgressHubOnMainThread()
    }
}
