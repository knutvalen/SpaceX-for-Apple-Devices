//
//  BuildEnvironment.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 20/09/2024.
//

import Foundation

enum BuildEnvironment {
    case development
    case production
}

var buildEnvironment: BuildEnvironment = {
    #if DEV
        return .development
    #else
        return .production
    #endif
}()
