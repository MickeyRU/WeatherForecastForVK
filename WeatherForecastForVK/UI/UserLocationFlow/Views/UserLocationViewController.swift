import UIKit

final class UserLocationViewController: UIViewController {
    
    private let router: NavigationRouterProtocol
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .mainBackgroud
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let footerView = FooterView()
        
    init(router: NavigationRouterProtocol) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        [bgImageView, footerView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        [bgImageView, footerView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 88)
        ])
    }
}
