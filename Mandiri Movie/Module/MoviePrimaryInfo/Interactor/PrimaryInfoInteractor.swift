//
//  PrimaryInfoInteractor.swift
//  Mandiri Movie
//
//  Created by Nicholas on 13/04/22.
//

import Foundation
import Alamofire

enum ImageType {
    case backdrop
    case poster
}

protocol PrimaryInfoInteractorContract: AnyInteractor {
    func getImage(for movie: Movie?, type: ImageType?)
    func getMovieDetails(for movieId: Int?)
    func getTrailers(for movie: Movie?)
    func getReviews(for movie: Movie?)
}

class PrimaryInfoInteractor: PrimaryInfoInteractorContract {
    var presenter: AnyPresenter?
    var currentPage: Int? = nil
    var pageLimit: Int? = nil
    
    func getMovieDetails(for movieId: Int?) {
        AF.request(URLConstants.getMovieDetailURL(with: movieId)).response { [weak self] response in
            guard let presenter = self?.presenter as? PrimaryInfoPresenterContract else {
                return
            }
            
            if let data = response.data {
                do {
                    let movie = try JSONDecoder().decode(Movie.self, from: data)
                    presenter.interactorDidFetchMovieDetails(with: .success(movie))
                } catch {
                    presenter.interactorDidFetchMovieDetails(with: .failure(error))
                }
            } else if let error = response.error {
                presenter.interactorDidFetchMovieDetails(with: .failure(error))
            }
        }
    }
    
    func getImage(for movie: Movie?, type: ImageType?) {
        var url = ""
        
        switch type {
        case .backdrop:
            url = URLConstants.getImageURL(by: movie!.backdrop_path)
        case .poster:
            url = URLConstants.getImageURL(by: movie!.poster_path)
        case .none:
            url = ""
        }
        
        AF.request(url, method: .get).response { [weak self] response in
            guard let presenter = self?.presenter as? PrimaryInfoPresenterContract else {
                return
            }

            if let data = response.data {
                presenter.interactorDidFetchImg(with: .success(data), type: type!)
            } else if let error = response.error {
                presenter.interactorDidFetchImg(with: .failure(error), type: type!)
            }
        }
    }
    
    func getTrailers(for movie: Movie?) {
        AF.request(URLConstants.getVideosURL(for: movie?.id ?? 0)).response { [weak self] response in
            guard let presenter = self?.presenter as? PrimaryInfoPresenterContract else {
                return
            }
            
            if let data = response.data {
                do {
                    let decode = try JSONDecoder().decode(BaseVideos.self, from: data)
                    let filtered = decode.results?.filter({ video in
                        video.type?.contains("Trailer") ?? true
                    })
                    presenter.interactorDidFetchTrailer(with: .success(filtered ?? [Video]()))
                } catch {
                    presenter.interactorDidFetchTrailer(with: .failure(error))
                }
            } else if let error = response.error {
                presenter.interactorDidFetchTrailer(with: .failure(error))
            }
        }
    }
    
    func getReviews(for movie: Movie?) {
        if currentPage != nil {
            currentPage! += 1
        }
        let url = URLConstants.getReviewsURL(for: movie?.id ?? 0, on: currentPage)
        
        AF.request(url).response { [weak self] response in
            guard let presenter = self?.presenter as? PrimaryInfoPresenterContract else {
                return
            }
            
            if let data = response.data {
                if let pageLimit = self?.pageLimit,
                   let currentPage = self?.currentPage,
                   pageLimit <= currentPage {
                    presenter.interactorDidFetchReviews(with: .failure(MoviesNetworkError.pageEnded))
                } else {
                    do {
                        let decode = try JSONDecoder().decode(BaseReviews.self, from: data)
                        self?.pageLimit = decode.total_pages
                        self?.currentPage = decode.page
                        presenter.interactorDidFetchReviews(with: .success(decode.results ?? [Review]()))
                    } catch {
                        presenter.interactorDidFetchReviews(with: .failure(error))
                    }
                }
            } else if let error = response.error {
                presenter.interactorDidFetchReviews(with: .failure(error))
            }
        }
    }
    
}
