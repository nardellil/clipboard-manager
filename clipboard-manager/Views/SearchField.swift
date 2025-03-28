//
//  SearchField.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 27/03/25.
//
import SwiftUI

struct SearchField: View {
    @FocusState private var isSearchFieldFocused: Bool
    @State private var text: String = ""
    var onTextChange: (String) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
            TextField("Search", text: $text).textFieldStyle(.plain).onChange(of: text) {
                _, newValue in onTextChange(newValue)
            }.focused($isSearchFieldFocused)
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    onTextChange("")
                }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
                }.buttonStyle(.plain)
            }
        }
        .padding(8)
        .cornerRadius(8)
    }
}

#Preview {
    SearchField(onTextChange: {_ in}).frame(width: 300)
}
