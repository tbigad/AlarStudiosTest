//
//  Backend.swift
//  AlarStudiosTest
//
//  Created by Pavel Nadolski on 28.11.2020.
//

import Foundation

fileprivate var loginUrlString = String( "https://www.alarstudios.com/test/auth.cgi")
fileprivate var dataUrlString = String("https://www.alarstudios.com/test/data.cgi")

struct LoginResponse : Codable {
    let status:String?
    let code:String?
}

struct DataResponce: Codable {
    let status: String
    let page: Int
    let data: Places
}

struct DataItem: Codable {
    let id, name: String
    let country: String
    let lat, lon: Double
    var imageUrl:URL? {
        let number = Int.random(in: 0..<10)
        var components = URLComponents(string: "https://picsum.photos/100/100")
        components?.queryItems = [URLQueryItem(name: "random", value: String(number))]
        return components?.url
    }
}

typealias Places = [DataItem]

enum LoginError:LocalizedError {
    case loginIncorrect
    
    var errorDescription: String? {
        switch self {
        case .loginIncorrect:
            return "Incorrect Login or/and Password"
        }
    }
    
}

class Backend {
    
    init() {
        fatalError() //Only static functions
    }
    
    static func login(login:String, password:String, complition:@escaping ((Result<String,Error>)->()) ) {
        var components = URLComponents(string: loginUrlString)
        components?.queryItems = [URLQueryItem(name: "username", value: login), URLQueryItem(name: "password", value: password)]
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                complition(.failure(error))
                return
            }
            guard let data = data else {return}
            let loginResponse:LoginResponse?
            do {
                loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            } catch let error {
                complition(.failure(error))
                return
            }
            
            if loginResponse?.status == "ok" {
                complition(.success(loginResponse!.code!))
            } else {
                complition(.failure(LoginError.loginIncorrect))
            }
        }
        task.resume()
    }
    
    static func data(code:String,page:Int, complition:@escaping ((Result<Places,Error>)->())) {
        var components = URLComponents(string: dataUrlString)
        components?.queryItems = [URLQueryItem(name: "code", value: code), URLQueryItem(name: "p", value: String(page))]
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                complition(.failure(error))
                return
            }
            guard let data = data else {return}
            let dataResponse:DataResponce?
            do {
                dataResponse = try JSONDecoder().decode(DataResponce.self, from: data)
            } catch let error {
                complition(.failure(error))
                return
            }
            
            if dataResponse?.status == "ok" {
                complition(.success(dataResponse!.data))
            } else {
                complition(.failure(LoginError.loginIncorrect))
            }
        }
        task.resume()
    }
}
