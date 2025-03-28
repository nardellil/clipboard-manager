//
//  ClipRow.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 27/03/25.
//
import SwiftUI

struct ClipRow: View {
    let index: Int
    let item: ClipItem
    let search: String
    let selected: Bool
    
    @State private var isHovering = false
    @State private var isHoveringMenu = false

    var body: some View {
        HStack(spacing: 0) {
            if selected {
                Rectangle().fill(.blue).frame(width: 4)
            } else {
                Spacer().frame(width: 4)
            }
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ClipTextContent(text: item.value, selection: search).padding(4)
                    if isHovering {
                        Menu {
                            Button(role: .destructive) {
                                DBService.deleteItem(index)
                            } label: {
                                Label("Elimina", systemImage: "trash").labelStyle(.titleAndIcon)
                        }
                        } label: {
                            Image(systemName: "ellipsis")
                        }.background(
                            RoundedRectangle(cornerRadius: 6).fill(isHoveringMenu ? Color.gray.opacity(0.2) : Color.clear)
                        )
                        .padding(.trailing, 12)
                        .offset(x: 4)
                        .onHover { hovering in
                            isHoveringMenu = hovering
                        }
                        .rotationEffect(.degrees(90))
                        .menuStyle(BorderlessButtonMenuStyle())
                        .menuIndicator(.hidden)
                        .transition(.opacity)
                    } else {
                        Spacer()
                    }
                }
                HStack(spacing: 0) {
                    if item.hits > 1 {
                        Text("Reused \(item.hits) times").font(.system(size: 8))
                            .foregroundColor(.secondary)
                            .padding(.leading, 10).padding(.bottom, 2)
                    }
                    Spacer()
                    Text(DateUtil.formatRelativeDate(from: item.timestamp))
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                        .padding(.trailing, 10).padding(.bottom, 2)
                }
                
            }
            
        }.onTapGesture {
            ClipboardService.pasteItem(DBService.getItemValue(item))
        }.onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
    }
}

#Preview {
    VStack() {
        ClipRow(index: 1, item: ClipItem(id: "1", value:"SampleClip", hits: 10), search: "Clip", selected: false)
    }
    .frame(width: 300)
}
