//
//  DiscoverMovieRouter.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation

protocol DiscoverMovieRouterContract: AnyRouter {
    static func start(with genre: Genre?) -> AnyRouter
}

class DiscoverMovieRouter: DiscoverMovieRouterContract {
    static func start() -> AnyRouter {
        let router = DiscoverMovieRouter(nil)
        
        // Assign VIP
        var view: AnyView = DiscoverMovieViewController()
        var presenter: AnyPresenter = DiscoverMoviePresenter(nil)
        var interactor: AnyInteractor = DiscoverMovieInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
    var entry: EntryPoint?
    var genre: Genre?
    
    init(_ genre: Genre?) {
        self.genre = genre
    }
    
    static func start(with genre: Genre?) -> AnyRouter {
        let router = DiscoverMovieRouter(genre)
        
        // Assign VIP
        var view: AnyView = DiscoverMovieViewController()
        var presenter: AnyPresenter = DiscoverMoviePresenter(genre?.id)
        var interactor: AnyInteractor = DiscoverMovieInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
}
