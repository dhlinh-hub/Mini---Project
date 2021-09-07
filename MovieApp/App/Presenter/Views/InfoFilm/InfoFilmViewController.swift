//
//  InfoFilmViewController.swift
//  MovieApp
//
//  Created by Ishipo on 18/06/2021.
//

import UIKit
import youtube_ios_player_helper
import Cosmos


class InfoFilmViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tagButton: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var voteRatingLabel: UILabel!
    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var movieLogo: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var playerVIew: YTPlayerView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var similarCollectionView: UICollectionView!
    @IBOutlet weak var stateSimilarMovieLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingButton: UIButton!
    
    var dataF : Movies? {
        didSet{
            if let dataF = dataF {
                viewModels.getCastData(dataF)
                viewModels.getVideo(dataF)
                viewModels.getSimilarMovies(dataF)
                if let path = dataF.poster_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
                    imageBG.kf.setImage(with: url)
                }else {
                    imageBG.image = UIImage(named: "default")
                }
                ratingLabel.text = "\(dataF.vote_average!)"
                voteRatingLabel.text = "\(dataF.vote_count!) user rating"
                titleLabel.text = "\(dataF.title!)"
                overViewLabel.text = "\(dataF.overview!)"
                stateLabel.text = "Release: \(dataF.release_date!)   View: \(dataF.popularity!)"
                if  dataF.bookmark {
                    tagButton.image = UIImage(systemName: "bookmark")?.withRenderingMode(.alwaysOriginal)
                    
                }
            }
        }
        
    }
    var dataR : Movies? {
        didSet{
            if let data = dataR {
                viewModels.getCastR(data)
                viewModels.getVideoR(data)
                viewModels.getSimilarMoviesR(data)
                if let path = data.poster_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
                    imageBG.kf.setImage(with: url)
                }else {
                    imageBG.image = UIImage(named: "default")
                }
                ratingLabel.text = "\(data.vote_average!)"
                voteRatingLabel.text = "\(data.vote_count!) user rating"
                titleLabel.text = "\(data.title!)"
                overViewLabel.text = "\(data.overview!)"
                stateLabel.text = "Release: \(data.release_date!)   View: \(data.popularity!)"
                if  data.bookmark {
                    tagButton.image = UIImage(systemName: "bookmark.fill")?.withRenderingMode(.alwaysOriginal)
                    
                }
            }
        }
        
    }
    private var castD = [Cast]()
    private var videos: Videos?
    private var similar = [Movies]()
    private  var isState = true
    private  var viewModels = InfoMovieViewModels()
    private var starRating : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        regisCollectionView()
        viewModels.delegate = self
        playerVIew.delegate = self
        ratingView.settings.fillMode = .half
        ratingView.didTouchCosmos = { rating in
            self.saveRating(rating)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.collectionView.reloadData()
            self.similarCollectionView.reloadData()
            
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    private func setupConfig() {
        
        tagButton.layer.cornerRadius = 25
        videoButton.layer.cornerRadius = 25
        checkButton.layer.cornerRadius = 15
        checkButton.layer.borderWidth = 1
        checkButton.layer.borderColor = UIColor.orange.cgColor
        imageBG.layer.cornerRadius = 10
        collectionView.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0)
        ratingButton.layer.cornerRadius = 5
        addHandleIcon()
        
        
        
    }
    internal func saveRating (_ rate : Double ) {
        starRating = rate
        print(starRating!)
        
    }
    
    private func addHandleIcon() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hiddenVideo))
        imageBG.addGestureRecognizer(tapGesture)
        imageBG.isUserInteractionEnabled = true
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleBookMark))
        tagButton.addGestureRecognizer(tapGesture2)
        tagButton.isUserInteractionEnabled = true
        
    }
    
    private func regisCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastCollectionViewCell")
        
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        similarCollectionView.register(UINib(nibName: "SimilarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SimilarCollectionViewCell")
        
    }
    @IBAction private func onRating(_ sender: Any) {
        viewModels.postRatingMovie(dataF!)
        //      viewModels.creatSession()
        
    }
    
    @IBAction private func clickBotButton(_ sender: Any) {
        guard let url = URL(string: "https://www.netflix.com/vn/") else {return}
        UIApplication.shared.open(url)
    }
    
    
    public func hiddenVideoButton() {
        videoButton.isHidden = true
        
    }
    public func hiddenSimilarMovieCollection() {
        similarCollectionView.isHidden = true
        stateSimilarMovieLabel.isHidden = false
    }
    
    @objc private func hiddenVideo() {
        playerVIew.isHidden = true
        
    }
    
    @IBAction private func onCheck(_ sender: Any) {
        guard let url = URL(string: "https://www.amazon.com/") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction private func onClose(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction private func onPlay(_ sender: Any) {
        guard let vd = videos else { return}
        playerVIew.isHidden = false
        playerVIew.load(withVideoId: vd.key!)
    }
    
    internal  func bookMarkIsSelect () {
        tagButton.image = UIImage(systemName: "bookmark.fill")?.withRenderingMode(.alwaysOriginal)
        UIView.transition(with: tagButton, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        
    }
    internal func bookMarkDeSelect () {
        tagButton.image = UIImage(systemName: "bookmark")?.withRenderingMode(.alwaysOriginal)
        UIView.transition(with: tagButton, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
    }
    
    
    
    //HandleBook Mark and save data on FireBase
    @objc private func handleBookMark() {
        if let data = dataF {
            viewModels.transitBookMark(data)
            
        }
        
        if let dataR = dataR {
            viewModels.transitBookMarkR(dataR)
            
        }
    }
    
    public func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -scrollView.contentInset.top - 20)
        self.scrollView.setContentOffset(desiredOffset, animated: true)
    }
    
    
    private func reloadViewController(_ movie : Movies) {
        dataF = movie
        viewWillAppear(true)
        viewDidLoad()
        scrollToTop()
        UIView.transition(with: view, duration: 1, options: .transitionCurlUp, animations: nil, completion: nil)
        
    }
    
}
extension InfoFilmViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == similarCollectionView {
            return similar.count
        }else{
            return castD.count
            
        }
    }
    
    func collectionView(_ collec: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collec == similarCollectionView {
            let smCell = similarCollectionView.dequeueReusableCell(withReuseIdentifier: "SimilarCollectionViewCell", for: indexPath)  as! SimilarCollectionViewCell
            smCell.data = similar[indexPath.row]
            
            return smCell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell
            cell.data = castD[indexPath.row]
            
            return cell
        }
    }
    
    
    func collectionView(_ collec: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.height
        let height = similarCollectionView.bounds.height
        if collec == similarCollectionView {
            return CGSize(width: height*0.75, height: height)
        }else{
            return CGSize(width: size/2 , height: size)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == similarCollectionView {
            return 10
        }else{
            return 0
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == similarCollectionView {
            return 20
        }else{
            return 0
        }
    }
    
    func collectionView(_ collection: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collection == similarCollectionView {
            
            reloadViewController(similar[indexPath.row])
            
        }else {
            let vc = CreditsViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: {
                vc.cast = self.castD[indexPath.row]
            })
        }
    }
    
    
}

extension InfoFilmViewController : YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
    }
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        playerView.isHidden = true
    }
}



extension InfoFilmViewController : InfoMovieViewModelsDelegate {
    
    func stateVideoR(_ video: Videos) {
        videos = video
    }
    
    func updateSimilarMovieR(_ movies: [Movies]) {
        similar = movies
    }
    
    func updateSimilarMovie(_ similarMovies: [Movies]) {
        similar = similarMovies
        similarCollectionView.reloadData()
    }
    
    func stateVideo(_ video: Videos) {
        videos = video
    }
    
    func updateCastR(_ cast: [Cast]) {
        castD = cast
    }
    
    func updateCast(_ cast: [Cast]) {
        castD = cast
        collectionView.reloadData()
    }
    
    func showLoading() {
        LoadingView.shared.showProgressHubOnMainThread()
    }
    
    func hideLoading() {
        LoadingView.shared.dismissProgressHubOnMainThread()
    }
}
