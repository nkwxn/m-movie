//
//  DiscoverMoviePresenter.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation

protocol DiscoverMoviePresenterContract: AnyPresenter {
    func interactorDidFetchMovies(with result: Result<[Movie], Error>)
    func loadMoreMovies()
}

class DiscoverMoviePresenter: DiscoverMoviePresenterContract {
    init(_ genre: Genre?) {
        self.genre = genre
    }
    
    var genre: Genre?
    
    var page: Int = 1
    
    var router: AnyRouter?
    var interactor: AnyInteractor? {
        didSet {
            if let interactor = interactor as? DiscoverMovieInteractorContract {
                interactor.getMovieDiscovery(with: genre?.id, on: nil)
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
            print("Should be success appending movies")
            page += 1
            view.update(with: genres)
        case .failure(let error):
            view.update(with: error.localizedDescription)
        }
    }
    
    func loadMoreMovies() {
        guard let interactor = interactor as? DiscoverMovieInteractorContract else {
            return
        }

        interactor.getMovieDiscovery(with: genre?.id, on: page)
    }
}
