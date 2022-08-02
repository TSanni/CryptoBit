//
//  CryptoManager.swift
//  CryptoBit
//
//  Created by Tomas Sanni on 7/31/22.
//

import Foundation

class CryptoManager: ObservableObject {
    @Published var rate: String = "0"
    
    let baseUrl = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "YOUR API KEY HERE"
    
    func getExchangeRate(with currency: String, and crypto: String) {
        let url = "\(baseUrl)/\(crypto)/\(currency)?apiKey=\(apiKey)" //order of cryto and currency matter on url for some reason
        
        
        //Step 1: Create the url
        if let url =  URL(string: url) {
            
            //Step 2: Create the URLSession
            let session = URLSession(configuration: .default)
            
            //Step 3: Give session a task
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print("Failed to perform request: \(e.localizedDescription)")
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(CoinData.self, from: safeData) {
                        
                        DispatchQueue.main.async {
//                            self.rate = String(format: "%.2f", decodedData.rate)
//                            let convertToDouble = Double(self.rate)
//                            print(self.rate)
//                            print("Converted to double: \(convertToDouble ?? 0)")
                            
                            
                            
                            let largeNumberInStringFormat = String(format: decodedData.rate < 1 ? "%.5f" : "%.2f", decodedData.rate)
                            let largeNumberConvertedToDouble = Double(largeNumberInStringFormat)
                            let numberFormatter = NumberFormatter()
                            numberFormatter.numberStyle = .decimal
                            self.rate = numberFormatter.string(from: NSNumber(value:largeNumberConvertedToDouble ?? 0)) ?? ""
                            
                            print("Large number: \(self.rate)")
                        }
                    } else {
                        print("Could not use decoder.")
                    }
                }
            }
            //Step 4: Start the task
            task.resume()
 
        }
    }
}


struct CoinData: Codable {
    let rate: Double
}
