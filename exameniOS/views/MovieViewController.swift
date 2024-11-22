//
//  ViewController.swift
//  exameniOS
//
//  Created by Victor Garcia on 20/11/24.
//

import UIKit
import Foundation

class MovieViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    private var viewModelMovies = moviesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewModel()
        tableView.dataSource = self
              tableView.delegate = self
        viewModelMovies.fetchMovies()
    }
    
    private func setupViewModel() {
        viewModelMovies.onMoviesUpdated = { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }

        viewModelMovies.onError = { error in
                print("Error: \(error)")
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            
            if let movie = sender as? Movie {
                if let detailsVC = segue.destination as? MovieDetailsViewController {
                    detailsVC.movie = movie
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelMovies.getMoviesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = viewModelMovies.getMovie(at: indexPath.row)
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! movieCell
        currentCell.movieTitle.text = movie.title
        return currentCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModelMovies.getMovie(at: indexPath.row)
        print("to details")
        performSegue(withIdentifier: "toDetails", sender: movie)
    }

}

