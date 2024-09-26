//
//  Webcast.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 19/09/2024.
//

import Foundation

struct Webcast: Codable {
    var publisher: String?
    var type: WebcastType
    var url: String
}