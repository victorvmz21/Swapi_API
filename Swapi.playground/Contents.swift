import UIKit

struct Person: Codable {
    let name: String
    let films: [URL]
    
}

struct Film: Codable {
    let title: String
    let opening_crawl: String
    let release_date: String
    let episode_id: Int
}

class SwapiService {
    
    static let baseURL = URL(string: "https://swapi.dev/api/")
    static let filmsEndPoint = "films"
    static let peopleEndPoint = "people"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        //MARK: Setting Up URL
        guard let baseURL = baseURL else { return completion(nil) }
        let url = baseURL.appendingPathComponent(peopleEndPoint)
        let finalURL = url.appendingPathComponent("\(id)")
        print(finalURL)
        
        //MARK: Creating Request
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            //taking care of Errors
            if let error = error {
                print(error.localizedDescription)
            }
            
            //safe unwrapping data
            guard let data = data else { return completion(nil) }
            let decoder = JSONDecoder()
            
            do {
                let people = try decoder.decode(Person.self, from: data)
                completion(people)
            } catch let error {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        //MARK: Setting up URL
        print(url)
        
        //Start Request
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return completion(nil) }
            let decoder = JSONDecoder()
            
            do {
                let films = try decoder.decode(Film.self, from: data)
                completion(films)
            } catch {
                completion(nil)
            }
        }.resume()
    }
}


func fetchFilm(url: URL) {
  SwapiService.fetchFilm(url: url) { film in
      if let film = film {
          print(film)
      }
  }
}
SwapiService.fetchPerson(id: 7) { (people) in
    if let person = people {
        print(person.name)
        for films in person.films {
            fetchFilm(url: films)
        }
    }
}




