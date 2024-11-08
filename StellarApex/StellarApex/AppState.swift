import Foundation

struct AppState {
    let apiService: IApiService

    init() {
        #if DEBUG
            apiService = ApiService(
                httpService: HttpService(
                    logger: HttpLogger(
                        simpleLog: false,
                        redactableHeaders: [],
                        redactHeaders: false,
                        redactBody: false,
                        prettyPrintBody: true
                    )
                )
            )
        #elseif DEBUGFAKE
            apiService = FakeApiService()
        #else
            apiService = ApiService(
                httpService: HttpService(
                    logger: HttpLogger(
                        simpleLog: true,
                        redactableHeaders: [],
                        redactHeaders: true,
                        redactBody: true,
                        prettyPrintBody: true
                    )
                )
            )
        #endif
    }
}

var debugTag = "-debug-"
