//
//  ContentView.swift
//  CurrencyApp
//
//  Created by Oleh Pazynich on 2022/04/11.
//

import SwiftUI

struct CurrencyView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    @FocusState private var focusedField: Bool
    @State private var amountStr: String = ""
    
    var body: some View {
        Section {
            VStack(spacing: 15) {
               
                Picker("Current currency", selection: $viewModel.baseCurrency) {
                    ForEach(viewModel.nameList, id: \.self) { val in
                        Text(val)
                    }
                }
                    .padding()
                    .pickerStyle(.menu)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.blue.opacity(80), lineWidth: 2)
                        )
                    .onChange(of: viewModel.baseCurrency) { tag in viewModel.getQuotesThroughUSD() }
             
                TextField("Enter desirable value", text: $amountStr)
                    .keyboardType(.decimalPad)
                    .focused($focusedField)
                    .padding(5)
                    .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                
                
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 75, maximum: 200))], spacing: 14) {
                        ForEach(viewModel.quotesCurrentList, id: \.self) { item in
                            VStack {
                                Text(item.name)
                                Text(String(format: "%.4f", viewModel.amountCalculation(amount: amountStr, quoteCurrency: item.quoteCurrency)))
                                    .font(.caption)
                            }
                            .frame(height: 60)
                            .frame(minWidth: 75, maxWidth: 200)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(15)
                            .foregroundColor(.white)
                        }
                    }
                }
                .task {
                    await viewModel.getQuotes()
                }
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button("Done") {
                            focusedField = false
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CurrencyView()
        }
    }
}
