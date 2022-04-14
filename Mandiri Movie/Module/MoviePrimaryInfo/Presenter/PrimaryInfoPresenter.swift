//
//  PrimaryInfoPresenter.swift
//  Mandiri Movie
//
//  Created by Nicholas on 13/04/22.
//

import Foundation

protocol PrimaryInfoPresenterContract: AnyPresenter {
    var movie: Movie? { get set }
    
    func showMovieDetails()
    func interactorDidFetchMovieDetails(with result: Result<Movie, Error>)
    func interactorDidFetchImg(with result: Result<Data, Error>, type: ImageType)
    func interactorDidFetchTrailer(with result: Result<[Video], Error>)
    func loadMoreReviews()
    func interactorDidFetchReviews(with result: Result<[Review], Error>)
}

class PrimaryInfoPresenter: PrimaryInfoPresenterContract {
    var movie: Movie?
    
    var router: AnyRouter?
    var interactor: AnyInteractor? {
        didSet {
            // Function to get Image, Trailer videos, and comments
            if let interactor = interactor as? PrimaryInfoInteractorContract {
                interactor.getImage(for: movie, type: .backdrop)
                interactor.getImage(for: movie, type: .poster)
                interactor.getMovieDetails(for: movie?.id)
                interactor.getTrailers(for: movie)
                interactor.getReviews(for: movie)
            }
        }
    }
    
    var view: AnyView?
    
    init(with movie: Movie?) {
        self.movie = movie
    }
    
    // Throw all info to View
    func showMovieDetails() {
        guard let view = view as? PrimaryInfoViewContract else {
            return
        }

        view.showMovieDetails(with: movie)
    }
    
    func interactorDidFetchMovieDetails(with result: Result<Movie, Error>) {
        switch result {
        case let .success(movie):
            self.movie = movie
            showMovieDetails()
        case let .failure(error):
            (view as? PrimaryInfoViewContract)?.showError(with: error)
        }
    }
    
    func interactorDidFetchImg(with result: Result<Data, Error>, type: ImageType) {
        guard let view = view as? PrimaryInfoViewContract else {
            return
        }

        switch result {
        case let .success(data):
            switch type {
            case .backdrop:
                view.showBackdropImage(with: data)
            case .poster:
                view.showPosterImage(with: data)
            }
        case let.failure(error):
            view.showError(with: error)
        }
    }
    
    func interactorDidFetchTrailer(with result: Result<[Video], Error>) {
        guard let view = view as? PrimaryInfoViewContract else {
            return
        }
        
        switch result {
        case let .success(videos):
            view.showTrailerVideos(with: videos)
        case let .failure(error):
            view.showError(with: error)
        }
    }
    
    func loadMoreReviews() {
        guard let interactor = interactor as? PrimaryInfoInteractorContract else {
            return
        }

        interactor.getReviews(for: movie)
    }
    
    func interactorDidFetchReviews(with result: Result<[Review], Error>) {
        guard let view = view as? PrimaryInfoViewContract else {
            return
        }
        
        switch result {
        case let .success(reviews):
            view.updateReview(with: reviews)
        case let .failure(error):
            view.showError(with: error)
        }
    }
}
