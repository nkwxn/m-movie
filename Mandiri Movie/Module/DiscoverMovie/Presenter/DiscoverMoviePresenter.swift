//
//  DiscoverMoviePresenter.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation

protocol DiscoverMoviePresenterContract: AnyPresenter {
    func interactorDidFetchMovies(with result: Result<[Movie], Error>)
}

class DiscoverMoviePresenter: DiscoverMoviePresenterContract {
    init(_ genreId: Int?) {
        self.genreId = genreId
    }
    
    var genreId: Int?
    
    var router: AnyRouter?
    var interactor: AnyInteractor? {
        didSet {
            if let interactor = interactor as? DiscoverMovieInteractorContract {
                interactor.getMovieDiscovery(with: genreId, on: nil)
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
            view.update(with: genres)
        case .failure(let error):
            view.update(with: error.localizedDescription)
        }
    }
}
