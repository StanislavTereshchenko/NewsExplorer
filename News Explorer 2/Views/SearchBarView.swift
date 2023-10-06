//
//  SearchBarView.swift
//  News Explorer
//
//  Created by Stanislav Tereshchenko on 05.10.2023.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var onSearch: () -> Void 
    @State private var showingAlert = false
    var body: some View {
//        GeometryReader { geometry in
            HStack {
                TextField("Search", text: $searchText, onCommit: onSearch)
                    .padding(.horizontal, 10)
                    .frame(height: 30)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                
                Button(action: {
                    if searchText.count > 11 {
                        showingAlert = true
                    } else {
                        onSearch()
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .alert("Error\nThe length of the text cannot be more than 11 characters.", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
//        }
//        .frame(maxWidth: .infinity)
    }
}

