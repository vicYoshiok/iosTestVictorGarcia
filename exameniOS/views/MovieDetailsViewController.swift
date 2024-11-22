//
//  MovieDetailsViewController.swift
//  exameniOsVictorGarcia
//
//  Created by Victor Garcia on 21/11/24.
//
//
//  ViewController.swift
//  exameniOS
//
//  Created by Victor Garcia on 20/11/24.
//

import UIKit
import Foundation

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    var moviesViewModel1 = moviesViewModel()
    var posterPath = ""
    var movie: Movie?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie{
            self.movieTitle.text = String(movie.id) + " " + movie.title
            self.overviewLabel.text = movie.overview
            posterPath = movie.posterPath
            
        }
        moviesViewModel1.downloadImage(from: "https://image.tmdb.org/t/p/w500/" + posterPath) { [weak self] image in
                        
                        DispatchQueue.main.async {
                            if let image = image {
                                
                                self?.posterImage.image = image
                            } else {
                                
                                self?.posterImage.image = UIImage(named: "placeholder")
                            }
                        }
                    }
        
    }
    
    
    
    
    
    

}


