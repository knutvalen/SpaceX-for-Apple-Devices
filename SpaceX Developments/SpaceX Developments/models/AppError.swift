import Foundation

enum AppError: Error {
    case noData
    case invalidURL
    case response(Error? = nil)
    case decoding(Error)
    case unknown
}
