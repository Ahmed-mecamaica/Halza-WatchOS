//
//  APIService.swift
//  watch-Test WatchKit Extension
//
//  Created by Ahmed Medhat on 26/10/2021.
//

import Foundation

final class APIService {
    static let shared = APIService()
    private init() {}
    
    
    enum Endpoints {
        static let base = "https://test-covidcertificate-api.azurewebsites.net/"
        
        case qrCode
        
        var stringValue: String {
            switch self {
            case .qrCode:
                return Endpoints.base + "qrme?AccountId=ddf7c394-142b-40f5-9f5b-4af81c192c8b"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    func getQRMeScreenData(completion: @escaping (QRMeScreenResponse?, Error?) -> ()) {
        let task = URLSession.shared.dataTask(with: Endpoints.qrCode.url) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(QRMeScreenResponse.self, from: data)
                completion(result, nil)
            }
            catch {
                completion(nil, error)
            }
            
        }
        task.resume()
    }
}
