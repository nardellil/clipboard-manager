//
//  ClipList.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 27/03/25.
//
import SwiftUI

struct ClipsList: View {
    let clips: [ClipItem]
    let searchText: String
    let onClipSelected: (String) -> Void
    let selection: Int
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(clips.enumerated()), id: \.offset) { index, clip in
                        ClipRow(index: index, item: clip, search: searchText, selected: selection == index)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                    }
                }
                .padding(0)
            }
            .background(Color.clear)
            .onChange(of: selection) {
                scrollProxy.scrollTo(selection)
            }
        }
    }
}

#Preview {
    let clips = [
        ClipItem(id: "1", value:"SampleClip"),
        ClipItem(id: "2", value:"SampleClip")
    ]
    ClipsList(clips: clips, searchText: "", onClipSelected: {_ in}, selection: 0).frame(width: 300)
}
