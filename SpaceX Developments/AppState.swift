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

var debugTag = "-bug-"
