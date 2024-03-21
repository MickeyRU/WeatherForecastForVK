import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var navigationRouter: NavigationRouterProtocol?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        navigationRouter = NavigationRouter(navigationController: navigationController)
        navigationRouter?.startNavigation()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
