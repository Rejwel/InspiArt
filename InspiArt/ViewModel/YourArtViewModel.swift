//
//  YourArtViewModel.swift
//  InspiArt
//
//  Created by rey on 25/08/2021.
//

import Foundation

class YourArtViewModel: ObservableObject {
    @Published public private(set) var savedArts: [SavedArt] = []
    
    init() {
        savedArts = PersistenceController.shared.getAllArts()
    }
}
