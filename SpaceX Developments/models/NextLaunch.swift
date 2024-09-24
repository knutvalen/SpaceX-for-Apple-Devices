//
//  NextLaunch.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 19/09/2024.
//

import Foundation

struct NextLaunch: Decodable {
    var id: String
    var name: String
    var net: Date
    var netPrecision: DatePrecision
    var webcast: Webcast?

    enum CodingKeys: CodingKey {
        case id
        case name
        case net
        case netPrecision
        case webcast
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        net = try container.decode(Date.self, forKey: .net)
        netPrecision = try container.decode(DatePrecision.self, forKey: .netPrecision)
        webcast = try container.decodeIfPresent(Webcast.self, forKey: .webcast)
    }
}
