//
//  APIService.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/14/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import SVProgressHUD

class APIService: NSObject {
    
    static let sharedInstance = APIService()
    
    private func dismissHud() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    //login
    
    func HandleAdmonLogin(WithUrlString urlStr: String, base64Str: String, completion: @escaping (String) -> ()) {
        
        guard let url = URL(string: urlStr) else {
            completion("error")
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
//        let basic = "Basic c2phOnlEaSlSI2xHJTR6NmhSaygwUw=="
        let basic = "Basic " + base64Str
        
        print("base64: ", basic)
        
        request.addValue(basic, forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        
        SVProgressHUD.show()
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion("error")
                print("Error for login: ", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion("error")
                return }
            
            do {
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers   ) as? [String: Any] else { return completion("error") }
                
                if let result = json["code"] as? String {
                    completion(result)
                } else {
                    completion("error")
                }
                
                
            } catch let jsonErr {
                
                completion("error")
                print("Error serializing error: ", jsonErr)
            }
            
        }
        
        task.resume()
        
    }
    
    func fetchAircraftWithUrl(_ urlString: String, completion: @escaping ([Aircraft]) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        SVProgressHUD.show()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                
                self.dismissHud()
                
                print("fetchAircraftError: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                
                let aircrafts = try JSONDecoder().decode([Aircraft].self, from: data)
                
                self.dismissHud()
                completion(aircrafts)
                
            } catch let jsonErr {
                self.dismissHud()
                print("Error serializing fetch aircraft", jsonErr)
            }
            
            
        }.resume()
        
    }
    
    func fetchAircraft(completion: @escaping ([Aircraft]) -> ()) {
        
        fetchAircraftWithUrl(WebService.fetchAircraft.rawValue, completion: completion)
        
    }
    
    func fetchAirportsWithUrl(_ urlString: String, completion: @escaping ([Airport]) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        SVProgressHUD.show()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                
                self.dismissHud()
                
                print("fetchAircraftError: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                
                let airports = try JSONDecoder().decode([Airport].self, from: data)
                
                self.dismissHud()
                completion(airports)
                
            } catch let jsonErr {
                self.dismissHud()
                print("Error serializing fetch aircraft", jsonErr)
            }
        }.resume()
        
    }
    
    func fetchAirPorts(completion: @escaping ([Airport]) -> ()) {
        
        fetchAirportsWithUrl(WebService.fetchAirports.rawValue, completion: completion)
        
    }
    
    func fetchEmptyLegsWithUrl(_ urlString: String, completion: @escaping ([EmptyLeg]) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        SVProgressHUD.show()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                
                self.dismissHud()
                
                print("fetchAircraftError: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                
                let emptyLegs = try JSONDecoder().decode([EmptyLeg].self, from: data)
                
                self.dismissHud()
                completion(emptyLegs)
                
            } catch let jsonErr {
                self.dismissHud()
                print("Error serializing fetch aircraft", jsonErr)
            }
        }.resume()
        
    }
    
    func fetchEmptyLegs(completion: @escaping ([EmptyLeg]) -> ()) {
        
        fetchEmptyLegsWithUrl(WebService.fetchEmptyLegs.rawValue, completion: completion)
        
    }
    
    
}
