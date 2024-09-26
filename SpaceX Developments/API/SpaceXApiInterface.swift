//
//  SpaceXApiInterface.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 19/09/2024.
//

import Foundation

protocol SpaceXApiInterface {
    func getNextLaunch(completion: @escaping (Result<NextLaunch, AppError>) -> Void)
}
