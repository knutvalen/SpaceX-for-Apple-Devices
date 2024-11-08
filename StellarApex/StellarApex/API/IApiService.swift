protocol IApiService {
    func getLaunchDetails(for launchId: String, ignoreCache: Bool) async -> Result<LaunchDetails, AppError>
    func getNextLaunch(ignoreCache: Bool) async -> Result<LaunchDetails, AppError>
    func getPreviousLaunches(ignoreCache: Bool) async -> Result<[LaunchOverview], AppError>
    func getNewsArticles(launchServiceProviders: [LaunchServiceProvider], ignoreCache: Bool) async -> Result<[NewsArticle], AppError>
}
