//
//  DiscoverMovieViewController.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import UIKit

protocol DiscoverMovieViewContract: AnyView {
    func update(with movies: [Movie])
    func update(with error: String)
    func getMoreMovies()
}

class DiscoverMovieViewController: UIViewController, DiscoverMovieViewContract {
    var presenter: AnyPresenter?
    
    var movies: [Movie] = []
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    lazy var movieCollectionLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
        
        movieCollectionView
            .register(
                UINib(nibName: MovieCollectionViewCell.identifier, bundle: nil),
                forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
            )
        movieCollectionView.setCollectionViewLayout(movieCollectionLayout, animated: true)
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.isHidden = true
    }

    func update(with movies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            self?.movies.append(contentsOf: movies)
            self?.movieCollectionView.reloadData()
            if self?.movies.count == movies.count {
                self?.movieCollectionView.isHidden = false
            }
        }
    }
    
    func update(with error: String) {
        print(error)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            if self?.movies.count == 0 {
                self?.dismiss(animated: true)
            }
        }
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func getMoreMovies() {
        (presenter as? DiscoverMoviePresenterContract)?.loadMoreMovies()
    }
}

extension DiscoverMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        cell.setValue(with: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if UIDevice.current.orientation.isPortrait {
//            return CGSize(width: (self.view.frame.size.width / 2) - 40, height: 225)
//        } else {
//            return CGSize(width: (self.view.frame.size.height / 2) - 40, height: 225)
//        }
        return CGSize(width: (self.view.frame.size.width / 2) - 30, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let router = PrimaryInfoRouter.start(with: movies[indexPath.row])
        self.navigationController?.pushViewController(router.entry!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {
            print("Should load more movie pages")
            
            self.getMoreMovies()
        }
    }
}
