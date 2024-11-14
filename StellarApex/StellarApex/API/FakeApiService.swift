final class FakeApiService: IApiService {
    /**
     Milliseconds delay
     */
    private var randomDelay: Double {
        return 0
//        return Double.random(in: 500 ..< 2000)
    }

    func getLaunchDetails(for _: String, ignoreCache _: Bool) async -> Result<LaunchDetails, AppError> {
        return .failure(AppError.unknown)
    }

    func getNextLaunch(ignoreCache _: Bool) async -> Result<LaunchDetails, AppError> {
        try? await Task.sleep(for: .milliseconds(randomDelay))

        guard let nextLaunch = await StellarApexApp.fakeDataSource.nextLaunch else {
            return .failure(AppError.unknown)
        }

        return .success(nextLaunch)
    }

    func getPreviousLaunches(ignoreCache _: Bool) async -> Result<[LaunchOverview], AppError> {
        return .failure(AppError.unknown)
    }

    func getNewsArticles(launchServiceProviders _: [LaunchServiceProvider], ignoreCache _: Bool) async -> Result<[NewsArticle], AppError> {
        return .failure(AppError.unknown)
    }
}
