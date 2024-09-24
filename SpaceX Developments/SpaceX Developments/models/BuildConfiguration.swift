import Foundation

enum BuildConfiguration {
    case development
    case production
}

var buildConfiguration: BuildConfiguration = {
    #if DEBUG
        return .development
    #else
        return .production
    #endif
}()
