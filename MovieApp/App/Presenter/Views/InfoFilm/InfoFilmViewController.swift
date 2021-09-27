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
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var similarLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblGener: UILabel!
    @IBOutlet weak var titleGenner: UILabel!
    
    var data : Movies?
       
    var dataR : Movies? {
        didSet{
            if let data = dataR {
                
                viewModels.getCastR(data)
                viewModels.getVideoR(data)
                viewModels.getSimilarMoviesR(data)
                if let path = data.poster_path {
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
                    imageBG.kf.setImage(with: url, placeholder: UIImage(named: "default"))
                }
                ratingLabel.text = "\(data.vote_average!)"
                voteRatingLabel.text = "\(data.vote_count!) user rating"
                titleLabel.text = "\(data.title!)"
                overViewLabel.text = "\(data.overview!)"
                lblSubtitle.text = "\(data.tagline!)"
                if data.release_date != nil {
                    stateLabel.text = "Release: \(data.release_date!)   View: \(data.popularity!)"
                }else{
                    stateLabel.text = "Release: None!   View: \(data.popularity!)"
                    
                }
                if  data.bookmark {
                    tagButton.image = UIImage(systemName: "bookmark.fill")?.withRenderingMode(.alwaysOriginal)
                    
                }
            }
        }
        
    }
    private var castD = [Cast]()
    private var videos: Videos?
    private var similar = [Movies]()
    private  var viewModels = InfoMovieViewModels()
    private var starRating : Double?
    var arr = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    public func getMovieDetail(_ movie : Movies) {
        viewModels.getMovieDetail(movie)
        viewModels.getCastData(movie)
        viewModels.getVideo(movie)
        viewModels.getSimilarMovies(movie)
      
    }
    
    private func updateUI(_ movie : Movies) {
        ratingLabel.text = "\(movie.vote_average!)"
        voteRatingLabel.text = "\(movie.vote_count!) user rating"
        titleLabel.text = "\(movie.title!)"
        overViewLabel.text = "\(movie.overview!)"
        lblSubtitle.text = "\(movie.tagline!)"
        stateLabel.text = "Release: \(movie.release_date!)     Runtime: \(movie.runtime!)m "
        ////
        if let path = movie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
            imageBG.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        ///
        if  movie.bookmark {
            tagButton.image = UIImage(systemName: "bookmark")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    internal func saveRating (_ rate : Double ) {
        starRating = rate
        print(starRating!)
    }
    
    private func regisCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastCollectionViewCell")
        
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        similarCollectionView.register(UINib(nibName: "SimilarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SimilarCollectionViewCell")
    }
    
    public func hiddenVideoButton() {
        videoButton.isHidden = true
    }
    public func hiddenSimilarMovieCollection() {
        similarCollectionView.isHidden = true
        similarLabel.isHidden = true
    }
    
    internal func bookMarkIsSelect () {
        tagButton.image = UIImage(systemName: "bookmark.fill")?.withRenderingMode(.alwaysOriginal)
        UIView.transition(with: tagButton, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        
    }
    internal func bookMarkDeSelect () {
        tagButton.image = UIImage(systemName: "bookmark")?.withRenderingMode(.alwaysOriginal)
        UIView.transition(with: tagButton, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
    }

    @IBAction private func onRating(_ sender: Any) {
        viewModels.postRatingMovie(data!, starRating!)
    }
    
    @IBAction private func clickBotButton(_ sender: Any)  {
        if let url = URL(string: "\(data?.homepage ?? "")") {
            UIApplication.shared.openURL(url)
        }else {
            UIApplication.shared.openURL(URL(string: "https://www.netflix.com/vn/")!)
        }
    }
  
    @IBAction private func imdbAction(_ sender: Any) {
        guard let url = URL(string: "https://www.imdb.com/title/\(data?.imdb_id ?? "")/") else { return }
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
    
    @IBAction func hiddenVideoAction(_ sender: Any) {
        playerVIew.isHidden = true
        playerVIew.stopVideo()
    }
    
 
    //HandleBook Mark and save data on FireBase
    @IBAction func handleBookMark(_ sender: Any) {
        if let data = data {
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
        getMovieDetail(movie)
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
            smCell.updateUI(similar[indexPath.row])
            
            return smCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell
            cell.updateUI(castD[indexPath.row])
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
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        //        playerView.isHidden = true
    }
}

extension InfoFilmViewController : InfoMovieViewModelsDelegate {
    func infoMovie(_ movie: Movies) {
        updateUI(movie)
        data = movie
    }
    
    func genresMoie(_ gen: [Genres]) {
        arr = gen.map{$0.name!}
        switch arr.count {
        case 0:
            titleGenner.isHidden = true
        case 1:
            lblGener.text = "\(arr[0])"
        case 2:
            lblGener.text = "\(arr[0]) , \(arr[1])"
        case 3:
            lblGener.text = "\(arr[0]), \(arr[1]), \(arr[2])"
        case 4:
            lblGener.text = "\(arr[0]), \(arr[1]), \(arr[2]), \(arr[3])"
        default:
            break
        }
    }
    
    func hiddenCollectionView() {
        collectionView.isHidden = true
        castLabel.isHidden = true
    }
    
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
