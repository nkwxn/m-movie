//
//  DiscoverMovieInteractor.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import Foundation
import Alamofire

protocol DiscoverMovieInteractorContract: AnyInteractor {
    func getMovieDiscovery(with genreId: Int?)
}

enum MoviesNetworkError: Error {
    case pageEnded
    
    var localizedDescription: String {
        switch self {
        case .pageEnded:
            return "You have reach the end of the page"
        }
    }
}

class DiscoverMovieInteractor: DiscoverMovieInteractorContract {
    var presenter: AnyPresenter?
    var currentPage: Int? = nil
    var pageLimit: Int? = nil
    
    func getMovieDiscovery(with genreId: Int?) {
        if currentPage != nil {
            currentPage! += 1
        }
        let url = URLConstants.getDiscoverMovies(by: genreId, on: (currentPage ?? 1))
        print(url)
        AF.request(url, method: .get).response { [weak self] response in
            guard let presenter = self?.presenter as? DiscoverMoviePresenterContract else {
                return
            }

            if let data = response.data {
                if let pageLimit = self?.pageLimit,
                   let currentPage = self?.currentPage,
                   pageLimit <= currentPage {
                    presenter.interactorDidFetchMovies(with: .failure(MoviesNetworkError.pageEnded))
                } else {
                    do {
                        let resp = try JSONDecoder().decode(BaseMovies.self, from: data)
                        self?.pageLimit = resp.total_pages
                        self?.currentPage = resp.page
                        if let result = resp.results {
                            presenter.interactorDidFetchMovies(with: .success(result))
                        }
                        presenter.interactorDidFetchMovies(with: .success(resp.results!))
                    } catch {
                        presenter.interactorDidFetchMovies(with: .failure(error))
                    }
                }
            } else if let error = response.error {
                presenter.interactorDidFetchMovies(with: .failure(error))
            }
        }
    }
}
