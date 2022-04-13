//
//  PrimaryInfoRouter.swift
//  Mandiri Movie
//
//  Created by Nicholas on 13/04/22.
//

import Foundation

protocol PrimaryInfoRouterContract: AnyRouter {
    static func start(with movie: Movie?) -> AnyRouter
}

class PrimaryInfoRouter: PrimaryInfoRouterContract {
    var entry: EntryPoint?
    var movie: Movie?
    
    init(_ movie: Movie?) {
        self.movie = movie
    }
    
    static func start() -> AnyRouter {
        let router = PrimaryInfoRouter(nil)
        
        // Assign VIP
        var view: AnyView = PrimaryInfoViewController()
        var presenter: AnyPresenter = PrimaryInfoPresenter()
        var interactor: AnyInteractor = PrimaryInfoInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
    // TODO: Refactor if movie info initialized
    static func start(with movie: Movie?) -> AnyRouter {
        let router = PrimaryInfoRouter(movie)
        
        // Assign VIP
        var view: AnyView = PrimaryInfoViewController()
        var presenter: AnyPresenter = PrimaryInfoPresenter()
        var interactor: AnyInteractor = PrimaryInfoInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
}
