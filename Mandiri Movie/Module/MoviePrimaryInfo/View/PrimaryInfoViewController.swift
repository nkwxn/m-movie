//
//  PrimaryInfoViewController.swift
//  Mandiri Movie
//
//  Created by Nicholas on 13/04/22.
//

import UIKit
import AVFoundation
import AVKit

enum ImageLoadError: Error {
    case backdropNotFound
    case posterNotFound
    
    var localizedDescription: String {
        switch self {
        case .posterNotFound:
            return "Poster not found"
        case .backdropNotFound:
            return "Backdrop not found"
        }
    }
}

protocol PrimaryInfoViewContract: AnyView {
    var movie: Movie? { get set }
    
    func showBackdropImage(with data: Data)
    func showPosterImage(with data: Data)
    func showMovieDetails(with movie: Movie?)
    func showTrailerVideos(with videos: [Video])
    func updateReview(with reviews: [Review])
    func showError(with error: Error)
}

class PrimaryInfoViewController: UIViewController, PrimaryInfoViewContract {
    var presenter: AnyPresenter?
    
    var movie: Movie?
    var trailers: [Video] = []
    var reviews: [Review] = []
    
    @IBOutlet weak var backdropImg: UIImageView!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var origTitleLbl: UILabel!
    @IBOutlet weak var taglineLbl: UILabel!
    @IBOutlet weak var movieSegmentControl: UISegmentedControl!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        self.navigationItem.largeTitleDisplayMode = .never
        // Navigation Bar Appearance
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .none
        appearance.backgroundEffect = .none
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        // Set to different view (large title, regular title, scroll, etc)
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        posterImg.layer.zPosition = 10
        print(movieSegmentControl.selectedSegmentIndex)
        
        // Setup collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 20, bottom: 10, right: 20)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        detailsCollectionView.setCollectionViewLayout(layout, animated: false)
        
        // Register cells
        detailsCollectionView
            .register(
                TextOnlyCollectionViewCell.nib(),
                forCellWithReuseIdentifier: TextOnlyCollectionViewCell
                    .identifier
            )
        detailsCollectionView
            .register(
                TextImageCollectionViewCell.nib(),
                forCellWithReuseIdentifier: TextImageCollectionViewCell.identifier
            )
        detailsCollectionView
            .register(
                MovieReviewCollectionViewCell.nib(),
                forCellWithReuseIdentifier: MovieReviewCollectionViewCell
                    .identifier
            )
        detailsCollectionView
            .register(
                TrailerCardCollectionViewCell.nib(),
                forCellWithReuseIdentifier: TrailerCardCollectionViewCell
                    .identifier
            )
        
        // Register Header
        detailsCollectionView
            .register(
                HeaderCollectionReusableView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HeaderCollectionReusableView.identifier
            )
        
        detailsCollectionView.delegate = self
        detailsCollectionView.dataSource = self
    }
    
    @IBAction func segmentDidChanged(_ sender: UISegmentedControl) {
        print("Segment Changed: \(sender.selectedSegmentIndex)")
        self.detailsCollectionView.reloadData()
    }
    
    func showBackdropImage(with data: Data) {
        let image = UIImage(data: data)
        self.backdropImg.image = image
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.navigationController?.navigationBar.tintColor = .white
        }
    }
    
    func showPosterImage(with data: Data) {
        let image = UIImage(data: data)
        self.posterImg.image = image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let presenter = presenter as? PrimaryInfoPresenterContract else {
            return
        }
        presenter.showMovieDetails()
    }
    
    func showMovieDetails(with movie: Movie?) {
        guard let movie = movie else {
            return
        }

        self.movieTitleLbl.text = movie.title
        if movie.title == movie.original_title {
            self.origTitleLbl.isHidden = true
        } else {
            self.origTitleLbl.text = "\(movie.original_title ?? "") (\(movie.original_language?.uppercased() ?? ""))"
        }
        
        if let tagline = movie.tagline {
            self.taglineLbl.text = tagline
            self.taglineLbl.isHidden = false
        }
        
        self.movie = movie
        
        detailsCollectionView.reloadData()
    }
    
    func showTrailerVideos(with videos: [Video]) {
        self.trailers = videos
        self.detailsCollectionView.reloadData()
    }
    
    func updateReview(with reviews: [Review]) {
        self.reviews.append(contentsOf: reviews)
        self.detailsCollectionView.reloadData()
    }
    
    func showError(with error: Error) {
        if (error as! MoviesNetworkError) != .pageEnded {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
}

extension PrimaryInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            switch movieSegmentControl.selectedSegmentIndex {
            case 0: return 1
            case 1: return trailers.count
            case 2: return reviews.count
            default: return 1
            }
        case 1: return movie?.genres?.count ?? 0
        case 2: return 4
        default: return movie?.production_companies?.count ?? 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch movieSegmentControl.selectedSegmentIndex {
        case 0:
            return 4
        default:
            return 1
        }
    }
    
    // Dequeue cell for different section
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch movieSegmentControl.selectedSegmentIndex {
        case 0:
            if indexPath.section == 3 {
                // New cell containing thumbnail image
                let prodComp = self.movie?.production_companies?[indexPath.row]
                let cell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: TextImageCollectionViewCell.identifier,
                        for: indexPath
                    ) as! TextImageCollectionViewCell
                cell.setImage(from: URLConstants.getImageURL(by: prodComp?.logo_path))
                cell.labelView.text = prodComp?.name
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextOnlyCollectionViewCell.identifier, for: indexPath) as! TextOnlyCollectionViewCell
                guard let movie = self.movie else {
                    cell.textLabel.text = "Cannot fetch movie information"
                    return cell
                }
                switch indexPath.section {
                case 0:
                    cell.textLabel.text = movie.overview
                case 1:
                    cell.textLabel.text = movie.genres![indexPath.row].name
                case 2:
                    switch indexPath.row {
                    case 0:
                        cell.textLabel.text = "Release date: \(movie.getReleaseDate())"
                    case 1:
                        cell.textLabel.text = "Revenue: \(movie.getFormattedRevenue())"
                    case 2:
                        cell.textLabel.text = "Runtime: \(movie.formatRuntime())"
                    case 3:
                        cell.textLabel.text = "User Score: \(movie.vote_average! * 10)%"
                    default:
                        cell.textLabel.text = "Release date, revenue, rumtime, user score"
                    }
                default:
                    cell.textLabel.text = "Other informations"
                }
                return cell
            }
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrailerCardCollectionViewCell.identifier, for: indexPath) as! TrailerCardCollectionViewCell
            cell.setupView(with: trailers[indexPath.row])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieReviewCollectionViewCell.identifier, for: indexPath) as! MovieReviewCollectionViewCell
            cell.setupContent(with: reviews[indexPath.row])
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextOnlyCollectionViewCell.identifier, for: indexPath) as! TextOnlyCollectionViewCell
            cell.textLabel.text = "Section not available"
            return cell
        }
    }
    
    // Dequeue header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderCollectionReusableView.identifier,
            for: indexPath
        ) as! HeaderCollectionReusableView
        header.configure()
        if movieSegmentControl.selectedSegmentIndex == 0 {
            switch indexPath.section {
            case 0:
                header.label.text = "Synopsis"
            case 1:
                header.label.text = "Genres"
            case 2:
                header.label.text = "Information"
            case 3:
                header.label.text = "Production Companies"
            default:
                header.label.text = ""
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if self.movieSegmentControl.selectedSegmentIndex == 0 {
            return .init(width: 0, height: 35)
        } else {
            return .zero
        }
    }
    
    // Set cell size (make different for each sections)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(
                width: view.bounds.width - 40,
                height: 0
            )
        case 1:
            return CGSize(width: movie?.genres?.count ?? 0 > 1 ? (view.bounds.width / 2) - 25 : view.bounds.width - 40, height: 40)
        case 2:
            return CGSize(
                width: view.bounds.width - 40,
                height: 0
            )
        default:
            return CGSize(width: movie?.genres?.count ?? 0 > 1 ? (view.bounds.width / 3) - 20 : view.bounds.width - 40, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.movieSegmentControl.selectedSegmentIndex == 2 && indexPath.row == reviews.count - 1 {
            (presenter as! PrimaryInfoPresenterContract).loadMoreReviews()
        }
    }
}
