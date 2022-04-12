//
//  GenreListViewController.swift
//  Mandiri Movie
//
//  Created by Nicholas on 12/04/22.
//

import UIKit

protocol GenreViewContract: AnyView {
    func update(with users: [Genre])
    func update(with error: String)
}

class GenreListViewController: UIViewController, GenreViewContract {
    var presenter: AnyPresenter?
    @IBOutlet weak var genreTableView: UITableView!
    
    var genres: [Genre] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeView()
    }
    
    func initializeView() {
        genreTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        genreTableView.delegate = self
        genreTableView.dataSource = self
        genreTableView.isHidden = true
        title = "Genres"
    }
    
    func update(with genres: [Genre]) {
        DispatchQueue.main.async {
            self.genres = genres
            self.genreTableView.reloadData()
            self.genreTableView.isHidden = false
        }
    }
    
    func update(with error: String) {
        print(error)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GenreListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = genres[indexPath.row].name
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let discoverRouter = DiscoverMovieRouter.start(with: genres[indexPath.row])
        let vc = discoverRouter.entry!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
