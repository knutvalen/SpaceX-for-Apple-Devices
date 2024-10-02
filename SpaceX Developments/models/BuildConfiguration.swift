//
//  BuildConfiguration.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 20/09/2024.
//

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
