import UIKit

protocol NavigationRouterProtocol {
    func startNavigation()
    
}

final class NavigationRouter: NavigationRouterProtocol {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func startNavigation() {
        let rootViewController = UserLocationViewController(router: self)
        navigationController.pushViewController(rootViewController, animated: false)
    }
}
