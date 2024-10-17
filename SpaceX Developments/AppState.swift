//
//  AppState.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 17/10/2024.
//

import Foundation

class AppState: ObservableObject {
    static let singleton = AppState()
    let api: SpaceXApiService

    init() {
        let logger: HttpLogger = .init(simpleLog: false, redactableHeaders: [], redactHeaders: false, hideBody: false, prettyPrintBody: true)
        let httpService: HttpService = .init(logger: logger)
        api = .init(httpService: httpService)
    }
}
