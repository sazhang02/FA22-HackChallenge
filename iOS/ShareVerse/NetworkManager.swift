//
//  NetworkManager.swift
//  ShareVerse
//
//  Created by Miracle Zhang on 2022/12/1.
//

import Alamofire
import Foundation

class NetworkManager {
    
    static let host = "http://34.86.48.110/"
    
    static func getAllBorrows(completion: @escaping (BorrowResponse) -> Void) {
        let endpoint = "\(host)/tasks/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(BorrowResponse.self, from: data) {
                    completion(userResponse)
                } else {
                    print("Failed to decode getAllTasks")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func createBorrow(name: String, credit: Int, type: String, loc: String, des: String, completion: @escaping (Borrow) -> Void) {
        let endpoint = "\(host)/tasks/"
        let params: [String: String] = [
            "name": name,
            "credit": String(credit),
            "type": type,
            "loc":loc,
            "des":des
            
        ]
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode(Borrow.self, from: data){
                    completion(userResponse)
                } else {
                    print("Failed to decode createTask")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    static func updateBorrow(name: String, credit: Int, type: String, loc: String, des: String, completion: @escaping (Borrow) -> Void) {
        let endpoint = "\(host)/tasks/{id}/"
        let params: Parameters = [
            "name": name,
            "credit": String(credit),
            "type": type,
            "loc":loc,
            "des":des
        ]
        AF.request(endpoint, method: .put, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode(Borrow.self, from: data){
                    print(userResponse)
                    completion(userResponse)
                } else {
                    print("Failed to decode updateTask")
                }
            case .failure(let error):
                print("failed")
                print(error.localizedDescription)
            }
        }
    }
    
    }


