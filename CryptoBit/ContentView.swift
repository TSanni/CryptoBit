//
//  ContentView.swift
//  CryptoBit
//
//  Created by Tomas Sanni on 7/31/22.
//

import SwiftUI

struct ContentView: View {
    let screenWidth = UIScreen.main.bounds.width
    let backgroundColor = Color(red: 78/255, green: 148/255, blue: 79/255)
    let textColor = Color(red: 233/255, green: 239/255, blue: 192/255)
    let capsuleShapeLabelColor = Color(red: 131/255, green: 189/255, blue: 117/255, opacity: 0.9)
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let cryptoArray = ["BTC", "ETH", "USDT", "USDC", "BNB", "XRP", "ADA", "SOL", "DOGE", "DAI", "DOT"]
    
    let titilliumFontExtraLight = FontManager.TitilliumWeb.T_ExtraLight
    let titilliumFontLight = FontManager.TitilliumWeb.T_Light

    @StateObject var cryptoManager = CryptoManager()
    
    @State private var currencySelector = "AUD"
    @State private var cryptoSelector = "BTC"
    
    
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)

            VStack {
                Text("CryptoBit")
                    .foregroundColor(textColor)
                    .font(.custom(titilliumFontExtraLight, size: 50))
                    .bold()
                    .padding()
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .resizable()
                        .foregroundColor(backgroundColor)
                        .scaledToFit()
                        .background(Color.white)
                        .clipShape(Circle())
                        .padding([.leading, .top, .bottom])

                    Spacer()
                    Text("\(cryptoManager.rate) \(currencySelector)")
                        .font(.custom(titilliumFontExtraLight, size: 30))
                        .foregroundColor(textColor)
                        .padding(.trailing)
                }
                .frame(width: screenWidth * 0.90, height: 100)
                .background(capsuleShapeLabelColor)
                .clipShape(Capsule())
//                .padding()
                
                
                Spacer()
                
                HStack(spacing: 0) {
                    Picker(selection: $currencySelector, label: Text("Picker")) {

                        ForEach(currencyArray, id: \.self) { currency in
                            Text(currency)
                                .font(.custom(titilliumFontLight, size: 25))
                                .foregroundColor(textColor)
                        }
                    }
                    .frame(width: screenWidth / 2)
                    .compositingGroup()
                    .clipped()
                    
                    
                    Picker(selection: $cryptoSelector, label: Text("Picker")) {
                        ForEach(cryptoArray, id: \.self) { crypto in
                            Text(crypto)
                                .font(.custom(titilliumFontLight, size: 25))
                                .foregroundColor(textColor)

                        }
                    }
                    .frame(width: screenWidth / 2)
                    .compositingGroup()
                    .clipped()


                    
                }
                .pickerStyle(.wheel)

                
            }
        }
        .onChange(of: currencySelector) { newValue in
            print(newValue)
            cryptoManager.getExchangeRate(with: newValue, and: cryptoSelector)
        }
        .onChange(of: cryptoSelector) { newValue in
            cryptoManager.getExchangeRate(with: currencySelector, and: newValue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

