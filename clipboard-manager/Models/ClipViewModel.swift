//
//  ClipViewModel.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 28/03/25.
//
import Foundation
import Combine

class ClipsViewModel: ObservableObject {
    @Published var clips: [ClipItem] = []

    init() {
        // Imposta il listener di DBService per aggiornare i dati
        DBService.listener = { [weak self] in
            DispatchQueue.main.async {
                self?.clips = DBService.filteredItems
            }
        }

        // Carica inizialmente i dati
        self.clips = DBService.filteredItems
    }
}
