//
//  ClipTextContent.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 27/03/25.
//
import SwiftUI

struct ClipTextContent: NSViewRepresentable {
    var text: String
    var selection: String

    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
        textField.isSelectable = false
        textField.drawsBackground = false
        textField.isBezeled = false


        return textField
    }
    
    func updateNSView(_ textField: NSTextField, context: Context) {
        textField.stringValue = text
        if !selection.isEmpty {
            let attributedText = NSMutableAttributedString(string: text)
            let range = (text.uppercased() as NSString).range(of: selection.uppercased())
            if range.location != NSNotFound {
                attributedText.addAttribute(.backgroundColor, value: NSColor.selectedTextBackgroundColor, range: range)
            }
            textField.attributedStringValue = attributedText
        }
 
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 56),
            textField.widthAnchor.constraint(equalToConstant: 256)
        ])
    }
}

#Preview {
    VStack() {
        ClipTextContent(text: "SampleClip", selection: "Clip")
        ClipTextContent(text: " if !selection.isEmpty \n { let attributedText = NSMutableAttributedString(string: text) \n let range = (text as NSString).\nrange(of: selection)", selection: "NSMutable")
    }
    .frame(width: 300)
    
}
