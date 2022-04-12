//
//  VIPERContract.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import UIKit

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
}

protocol AnyView {
    var presenter: AnyPresenter? { get set }
}

protocol AnyPresenter {
    var router: AnyRouter? { get set }
    var interactor: AnyInteractor? { get set }
    var view: AnyView? { get set }
}

typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
    var entry: EntryPoint? { get }
    
    static func start() -> AnyRouter
}
