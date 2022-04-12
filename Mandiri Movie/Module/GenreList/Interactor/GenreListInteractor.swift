//
//  GenreListInteractor.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation
import Alamofire

protocol GenreInteractorContract: AnyInteractor {
    func getGenres()
}

class GenreListInteractor: GenreInteractorContract {
    var presenter: AnyPresenter?
    
    func getGenres() {
        AF.request(URLConstants.getGenres, method: .get).response { [weak self] response in
            guard let presenter = self?.presenter as? GenrePresenterContract else {
                return
            }
            if let data = response.data {
                do {
                    let response = try JSONDecoder().decode(BaseGenres.self, from: data)
                    presenter.interactorDidFetchGenres(with: .success(response.genres))
                } catch {
                    fatalError(error.localizedDescription)
                }
            } else if let error = response.error {
                presenter.interactorDidFetchGenres(with: .failure(error))
            }
        }
    }
}
