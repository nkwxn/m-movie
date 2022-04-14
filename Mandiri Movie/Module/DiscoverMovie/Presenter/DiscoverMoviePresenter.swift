//
//  DiscoverMoviePresenter.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation

protocol DiscoverMoviePresenterContract: AnyPresenter {
    var genre: Genre? { get set }
    
    func interactorDidFetchMovies(with result: Result<[Movie], Error>)
    func loadMoreMovies()
}

class DiscoverMoviePresenter: DiscoverMoviePresenterContract {
    init(_ genre: Genre?) {
        self.genre = genre
    }
    
    var genre: Genre?
    
    var router: AnyRouter?
    var interactor: AnyInteractor? {
        didSet {
            if let interactor = interactor as? DiscoverMovieInteractorContract {
                interactor.getMovieDiscovery(with: genre?.id)
            }
        }
    }
    var view: AnyView?
    
    func interactorDidFetchMovies(with result: Result<[Movie], Error>) {
        guard let view = view as? DiscoverMovieViewContract else {
            return
        }
        
        switch result {
        case .success(let genres):
            view.update(with: genres)
        case .failure(let error):
            view.update(with: error.localizedDescription)
        }
    }
    
    func loadMoreMovies() {
        guard let interactor = interactor as? DiscoverMovieInteractorContract else {
            return
        }

        interactor.getMovieDiscovery(with: genre?.id)
    }
}
