//
//  Art.swift
//  RandomArt
//
//  Created by Paweł Dera on 04/08/2021.
//
//

import Foundation
import SwiftUI
import Combine

public struct Art: Hashable {
    let id: Int
    let title: String
    let image_id: String
    let artist_display: String
    let when_added: Date?
}
