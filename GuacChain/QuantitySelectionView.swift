//
//  QuantitySelectionView.swift
//  GuacChain
//
//  Created by Francesca MACDONALD on 2023-09-05.
//

import SwiftUI

struct QuantitySelectionView: View {
    @Binding var quantity: Int
    @State var menuItem: String
    var body: some View {
        HStack {
            Text("\(quantity)")
                .font(.system(size: 48))
                .fontWeight(.heavy)
                .frame(width: 70)
            VStack (alignment: .leading, spacing: 0) {
                Text(menuItem)
                    .font(.title2)
                Stepper("", value: $quantity,
                        in: 0...99,
                        step: 1)
                .labelsHidden()
            }
            .minimumScaleFactor(0.5)
            .lineLimit(1)
        }
    }
}

struct QuantitySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        QuantitySelectionView(quantity: .constant(0), menuItem: "The Satoshi 'Taco' moto")
    }
}
