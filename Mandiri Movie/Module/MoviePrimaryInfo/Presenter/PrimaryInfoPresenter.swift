//
//  PrimaryInfoPresenter.swift
//  Mandiri Movie
//
//  Created by Nicholas on 13/04/22.
//

import Foundation

protocol PrimaryInfoPresenterContract: AnyPresenter {
    
}

class PrimaryInfoPresenter: PrimaryInfoPresenterContract {
    var router: AnyRouter?
    var interactor: AnyInteractor?
    var view: AnyView?
    
    
}
