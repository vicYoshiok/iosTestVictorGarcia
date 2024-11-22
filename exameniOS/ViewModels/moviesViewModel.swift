//
//  moviesViewModel.swift
//  exameniOsVictorGarcia
//
//  Created by Victor Garcia on 21/11/24.
//

import Foundation
import Alamofire
class moviesViewModel {
    
    private var movies: [Movie] = []
    
    var onMoviesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchMovies() {
        
        let urlString = "https://api.themoviedb.org/3/movie/157336?api_key=79b1da5c20e7d300c0d1baad5e36b3d5"
        AF.request(urlString).responseData{ [self]response in
            switch response.result{
            case .success(let data):
                do {
                    // Decodificar el JSONcasl
                    let decoder = JSONDecoder()
                    let moviesData = try decoder.decode(Movie.self, from: data)
                    
                    self.movies = [moviesData]
                    self.onMoviesUpdated?()
                    print("succes")
                    print(movies.first?.title ?? "title")
                    print(movies.first?.overview ?? "overview")
                    print(movies.first?.backdropPath ?? "backdropPath")
                    print(movies.first?.posterPath ?? "posterPath")
                } catch {

                    print("Error al decodificar el JSON: \(error)")
                }
            case .failure(_):
                print("error\(String(describing: Result<Data, AFError>.failure))")
                
            break
                
            }
            
        }
    }
    

    func getMoviesCount() -> Int {
        return movies.count
    }

    func getMovie(at index: Int) -> Movie {
        return movies[index]
    }
    
    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
            AF.request(url).responseData { response in
                if let data = response.data, let image = UIImage(data: data) {
                    
                    completion(image)
                } else {
                   
                    completion(nil)
                }
            }
        }
}

