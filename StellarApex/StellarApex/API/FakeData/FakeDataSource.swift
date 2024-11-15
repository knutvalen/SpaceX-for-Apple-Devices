import Foundation

struct FakeDataSource {
    var nextLaunch: LaunchDetails?

    init() {
        let decoder = JSONDecoder()

        do {
            decoder.dateDecodingStrategy = try JSONDecoder.DateDecodingStrategy.launchLibrary()
//            let data = loadJson(fileName: "spaceXStarlink")!
            let data = loadJson(fileName: "Progress MS-29")!
//            let data = loadJson(fileName: "Starship")!
            nextLaunch = try decoder.decode(LaunchDetails.self, from: data)
        } catch {
            debugPrint(error)
        }
    }

    private func loadJson(fileName: String) -> Data? {
        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                return try Data(contentsOf: file)
            } catch {
                debugPrint(error)
            }
        }

        return nil
    }
}
