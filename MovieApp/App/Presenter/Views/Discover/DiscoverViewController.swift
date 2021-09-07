//
//  DiscoverViewController.swift
//  MovieApp
//
//  Created by Ishipo on 18/06/2021.
//

import UIKit


class DiscoverViewController: UIViewController {
    
    
    var data = [Movies]()
    var viewModels = MoviesViewModels()
    var vc :FavoriteViewController?
    
    
    let segmentControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Movies","TV Show"])
        sc.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        
        sc.selectedSegmentTintColor = .red
        sc.selectedSegmentIndex = 0
        
        return sc
    }()
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout ()
        let cV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cV.translatesAutoresizingMaskIntoConstraints = false
        cV.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        cV.showsHorizontalScrollIndicator = false
        cV.showsVerticalScrollIndicator = false
        
        layout.scrollDirection = .vertical
        cV.register(UINib(nibName: "DiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiscoverCollectionViewCell")
        
        return cV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModels.vc = self
        viewModels.delegate = self
        data = viewModels.dataMV
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupConfig()
        viewModels.getMovies(1)
        
        
    }
    
    private func setupConfig() {
        
        var topbarHeight: CGFloat {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
        navigationItem.titleView = segmentControl
        view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.00)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: topbarHeight),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        segmentControl.addTarget(self, action: #selector(handleSegmenControl), for: .valueChanged)
        setupSeachIcon()
        
    }
    private func setupSeachIcon() {
        let seach = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        seach.setImage(UIImage(named: "seach"), for: .normal)
        seach.addTarget(self, action: #selector(gotoSeachVC), for: .touchUpInside)
        
        let seachButton = UIBarButtonItem(customView: seach)
        let currWidth = seachButton.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = seachButton.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        navigationItem.rightBarButtonItem = seachButton
        
    }
    
    internal func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -collectionView.contentInset.top - 50)
        self.collectionView.setContentOffset(desiredOffset, animated: true)
    }
    
    
    @objc func gotoSeachVC() {
        let vc  = UINavigationController(rootViewController: SeachViewController())
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}
extension DiscoverViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count - 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! DiscoverCollectionViewCell
        
        cell.data = data[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width) / 3.15
        return CGSize(width: width, height: width * 1.5)
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
        self.present(vc, animated: false, completion: {
            vc.dataF = self.data[indexPath.row]
        })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModels.scrollAppendData()
        
    }
    
    @objc func handleSegmenControl() {
        viewModels.handleSegment()
        
    }
}

extension DiscoverViewController: MoviesViewModelsDelegate {
    func updateMovies(_ movies: [Movies]) {
        data = movies
        reloadData()
        
        
    }
    
    func updateTVShow(_ tvShows: [Movies]) {
        data = tvShows
        reloadData()
    }
    
    func showLoading() {
        LoadingView.shared.showProgressHubOnMainThread()
    }
    
    func hideLoading() {
        LoadingView.shared.dismissProgressHubOnMainThread()
    }
}
