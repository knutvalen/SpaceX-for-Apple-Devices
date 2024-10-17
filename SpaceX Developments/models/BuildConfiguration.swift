import Foundation

enum BuildConfiguration {
    case development
    case production
}

var buildConfiguration: BuildConfiguration = {
    #if DEV
        return .development
    #else
        return .production
    #endif
}()
