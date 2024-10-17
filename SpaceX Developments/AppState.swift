//
//  AppState.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 17/10/2024.
//

import Foundation

class AppState: ObservableObject {
    static let singleton = AppState()
    let api: ApiService

    init() {
        api = ApiService(
            httpService: HttpService(
                logger: HttpLogger(
                    simpleLog: false,
                    redactableHeaders: [],
                    redactHeaders: false,
                    hideBody: false,
                    prettyPrintBody: true
                )
            )
        )
    }
}
