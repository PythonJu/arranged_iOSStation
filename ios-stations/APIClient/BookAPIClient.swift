//
//  BookAPIClient.swift
//  ios-stations
//
import UIKit
import Alamofire

protocol BookAPIClientProtocol {
    func fetchBooks(offset: Int, completion: @escaping (_ books: [Book]?) -> Void)
}

class BookAPIClient: BookAPIClientProtocol {
    var apiUrlString: String = "https://api-for-missions-and-railways.herokuapp.com/public/books?offset="
    func fetchBooks(offset: Int, completion: @escaping (_ books: [Book]?) -> Void) {
        let apiUrlStrings: String = apiUrlString + String(offset)
        AF.request(apiUrlStrings).responseJSON { response in
            do {
                let jsonData: Data = response.data!
                let jsonDecoder: [Book] = try JSONDecoder().decode([Book].self, from: jsonData)
                completion(jsonDecoder)
                
            } catch {
                print("----------------------------", error)
            }
        }
    }
}
