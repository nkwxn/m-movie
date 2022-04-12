//
//  GenreListRouter.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation
import UIKit

// Object
// Entry point

class GenreListRouter: AnyRouter {
    var entry: EntryPoint?
     
    static func start() -> AnyRouter {
        let router = GenreListRouter()
        
        // Assign VIP
        var view: AnyView = GenreListViewController()
        var presenter: AnyPresenter = GenreListPresenter()
        var interactor: AnyInteractor = GenreListInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
}
