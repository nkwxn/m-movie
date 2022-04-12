//
//  GenreListPresenter.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation

// Object
// Protocol
// Ref to interactor, router, view

protocol GenrePresenterContract: AnyPresenter {
    func interactorDidFetchGenres(with result: Result<[Genre], Error>)
}

enum FetchError: Error {
    case failed
}

class GenreListPresenter: GenrePresenterContract {
    var router: AnyRouter?
    var interactor: AnyInteractor? {
        didSet {
            if let interactor = interactor as? GenreInteractorContract {
                print("Should get genres")
                interactor.getGenres()
            }
        }
    }
    var view: AnyView?
    
    func interactorDidFetchGenres(with result: Result<[Genre], Error>) {
        guard let view = view as? GenreViewContract else {
            return
        }
        
        switch result {
        case .success(let genres):
            view.update(with: genres)
        case .failure(let error):
            view.update(with: error.localizedDescription)
        }
    }
}
