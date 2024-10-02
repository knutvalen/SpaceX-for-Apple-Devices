//
//  LaunchDetails.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 01/10/2024.
//

import Foundation

struct LaunchDetails: Decodable {
    var id: String
    var lastUpdated: Date
    var launchServiceProvider: LaunchServiceProvider
    var mission: Mission
    var name: String
    var net: Date
    var netPrecision: DatePrecision
    var patch: String?
    var status: Status
    var webcasts: [Webcast]

    enum CodingKeys: CodingKey {
        case id
        case lastUpdated
        case launchServiceProvider
        case mission
        case name
        case net
        case netPrecision
        case patch
        case status
        case webcasts
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        lastUpdated = try container.decode(Date.self, forKey: .lastUpdated)
        launchServiceProvider = try container.decode(LaunchServiceProvider.self, forKey: .launchServiceProvider)
        mission = try container.decode(Mission.self, forKey: .mission)
        name = try container.decode(String.self, forKey: .name)
        net = try container.decode(Date.self, forKey: .net)
        netPrecision = try container.decode(DatePrecision.self, forKey: .netPrecision)
        patch = try container.decodeIfPresent(String.self, forKey: .patch)
        status = try container.decode(Status.self, forKey: .status)
        webcasts = try container.decode([Webcast].self, forKey: .webcasts)
    }
}

struct Status: Decodable {
    var description: String
    var name: String

    enum CodingKeys: CodingKey {
        case description
        case name
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decode(String.self, forKey: .description)
        name = try container.decode(String.self, forKey: .name)
    }
}

struct Mission: Decodable {
    var description: String?
    var name: String
    var orbit: String
    var type: String

    enum CodingKeys: CodingKey {
        case description
        case name
        case orbit
        case type
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        name = try container.decode(String.self, forKey: .name)
        orbit = try container.decode(String.self, forKey: .orbit)
        type = try container.decode(String.self, forKey: .type)
    }
}

struct LaunchServiceProvider: Decodable {
    var description: String?
    var logo: String
    var name: String
    var url: String?
}
