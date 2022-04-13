//
//  DiscoverMovieInteractor.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation
import Alamofire

protocol DiscoverMovieInteractorContract: AnyInteractor {
    func getMovieDiscovery(with genreId: Int?, on page: Int?)
}

class DiscoverMovieInteractor: DiscoverMovieInteractorContract {
    var presenter: AnyPresenter?
    var pageLimit: Int = 0
    
    func getMovieDiscovery(with genreId: Int?, on page: Int? = nil) {
        AF.request(URLConstants.getDiscoverMovies(by: genreId, on: page), method: .get).response { [weak self] response in
            guard let presenter = self?.presenter as? DiscoverMoviePresenterContract else {
                return
            }

            if let data = response.data {
                do {
                    let resp = try JSONDecoder().decode(BaseMovies.self, from: data)
                    self?.pageLimit = resp.total_pages
                    presenter.interactorDidFetchMovies(with: .success(resp.results))
                } catch {
                    presenter.interactorDidFetchMovies(with: .failure(error))
                }
            } else if let error = response.error {
                presenter.interactorDidFetchMovies(with: .failure(error))
            }
        }
    }
}
