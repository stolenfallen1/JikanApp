//
//  ServiceManager.swift
//  JikanAPP
//
//  Created by stolenfallen1 on 7/22/25.
//

import Foundation

class ServiceManager {
    let jikanApiURL: String = "https://api.jikan.moe/v4"
    
    func getMangaList(id: Int) {
        let urlString: String = "\(jikanApiURL)/\(id)"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error  in
            if let error = error {
                print("ERROR!")
            }
            
            guard let data = data else {
                print("No Data Received")
                return
            }
            
            do {
                
            } catch {
                print("Something went wrong!")
            }
            
            
        }
        task.resume()
    }
    
    
}
