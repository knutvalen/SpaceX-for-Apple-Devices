//
//  AppError.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 19/09/2024.
//

import Foundation

enum AppError: Error {
    case noData
    case invalidPath
    case response(Error)
    case decoding(Error)
    case netPrecision(String)
}
