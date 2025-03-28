//
//  ContentView.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 27/03/25.
//

import SwiftUI

struct ContentView: View {
    @FocusState private var isSearchFieldFocused: Bool
    @State private var selection: Int = -1
    @State private var searchText: String = ""
    @StateObject private var clipsModel = ClipsViewModel()

    var body: some View {
        VStack (spacing: 0) {
            SearchField(onTextChange: {
                text in
                selection = -1
                searchText = text
                DBService.filter(text: text)
            }).focused($isSearchFieldFocused)
            ClipsList(clips: clipsModel.clips, searchText: searchText, onClipSelected: {_ in}, selection: selection)
        }.onAppear {
            isSearchFieldFocused = true
        }.onKeyPress(.downArrow) {
            selection = min(selection + 1, clipsModel.clips.count - 1)
            return .handled
        }.onKeyPress(.upArrow) {
            selection = max(0, selection - 1)
            return .handled
        }.onKeyPress(.return) {
            if (selection != -1) {
                ClipboardService.pasteItem(DBService.getItemValue(selection))
            }
            return .handled
        }.onKeyPress(.escape) {
            NSApplication.shared.hide(nil)
            return .handled
        }.background(.regularMaterial).cornerRadius(12)
    }
}

#Preview {
    ContentView().frame(width: 300, height: 400
    )
}
