//
//  ContentView.swift
//  GuacChain
//
//  Created by Francesca MACDONALD on 2023-09-05.
//

import SwiftUI
enum Currency: String, Equatable, CaseIterable {
    case usd = "$ USD"
    case gbp = "£ GBP"
    case eur = "€ EUR"
    
//    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue)}
}
enum price: Double, CaseIterable {
    case taco = 5.00
    case burrito = 8.00
    case chips = 3.00
    case horchata = 2.00
}
struct ContentView: View {
    @StateObject var currencyVM = CurrencyViewModel()

    @State private var tacoQty = 0
    @State private var burritoQty = 0
    @State private var horchataQty = 0
    @State private var chipsQty = 0
    @State private var currency: Currency = .usd
    @State private var totalCost = 0.0
    @State private var bitCoinCost = 0.0
    @State private var currencySymbol = "$"

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Guac")
                    .foregroundColor(.green)
                Text("Chain")
                    .foregroundColor(.red)
            }
            .font(Font.custom("Marker Felt", size: 48))
            .bold()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            
            Text("The World's Tastiest Tacos - But We Only Accept Bitcoin")
                .font(Font.custom("Papyrus", size: 20))
                .multilineTextAlignment(.center)
            Text("🌮")
                .font(.system(size: 80))
            VStack (alignment: .leading) {
                QuantitySelectionView(quantity: $tacoQty, menuItem: "The Satoshi 'Taco' moto")
                    .onChange(of: tacoQty) { _ in
                        calcBillInCurrency()
                    }
                QuantitySelectionView(quantity: $burritoQty, menuItem: "Bitcoin Burrito")
                    .onChange(of: burritoQty) { _ in
                        calcBillInCurrency()
                    }
                QuantitySelectionView(quantity: $chipsQty, menuItem: "CryptoChips")
                    .onChange(of: chipsQty) { _ in
                        calcBillInCurrency()
                    }
               QuantitySelectionView(quantity: $horchataQty, menuItem: "'No Bubbles' Horchata")
                    .onChange(of: horchataQty) { _ in
                        calcBillInCurrency()
                    }
                }
            Spacer()
            Picker("Currency", selection: $currency) {
                ForEach(Currency.allCases, id: \.self) { value in
                    Text(value.rawValue)
                        .tag(value)

                }
            }
            .pickerStyle(.segmented)
            .onChange(of: currency) { newValue in
                switch currency {
                case .usd:
                    currencySymbol = "$"
                case .gbp:
                    currencySymbol = "￡"
                case .eur:
                    currencySymbol = "€"
                }
                calcBillInCurrency()
            }
            HStack(alignment: .top){
                Text("Total:")
                VStack (alignment: .leading) {
                    Text("฿\(bitCoinCost)")
                    Text(currencySymbol + String(format: "%.2f", totalCost))
                }
            }
            .font(.title)
        }
        .padding()
        .onAppear {
            Task {
                await currencyVM.getData()
            }
        }
    }

    func calcBillInCurrency() {
        let dollarCost = Double(tacoQty) * price.taco.rawValue + Double(burritoQty) * price.burrito.rawValue + Double(chipsQty) * price.chips.rawValue + Double(horchataQty) * price.horchata.rawValue
        
        bitCoinCost = dollarCost / currencyVM.usdPerBTC
        
        switch currency {
        case .usd:
            totalCost = dollarCost
        case .gbp:
            totalCost = dollarCost * (currencyVM.gbpPerBTC / currencyVM.usdPerBTC)
        case .eur:
            totalCost = dollarCost * (currencyVM.eurPerBTC / currencyVM.usdPerBTC)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
