import Foundation

enum AppError: Error {
    case noData
    case invalidURL
    case response(Error?)
    case decoding(Error)
}
