import UIKit
import Combine

final class FooterView: UIView {
    private (set) var userLocationButtonTappedPublisher = PassthroughSubject<Void, Never>()
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .footerPicture
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var userLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(.currentLocation, for: .normal)
        button.tintColor = .primaryWhiteBlack
        button.addTarget(self, action: #selector(userLocationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var otherLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(.listWithLocations, for: .normal)
        button.tintColor = .primaryWhiteBlack
        button.addTarget(self, action: #selector(otherLocationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func userLocationButtonTapped() {
        userLocationButtonTappedPublisher.send()
    }
    
    @objc
    private func otherLocationButtonTapped() {
        print("otherLocationButtonTapped")
    }
    
    private func setupViews() {
        [bgImageView, userLocationButton, otherLocationButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        [bgImageView, userLocationButton, otherLocationButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            bgImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bgImageView.heightAnchor.constraint(equalToConstant: 88),
            
            userLocationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            userLocationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            userLocationButton.widthAnchor.constraint(equalToConstant: 44),
            userLocationButton.heightAnchor.constraint(equalToConstant: 44),
            
            otherLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            otherLocationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            otherLocationButton.widthAnchor.constraint(equalToConstant: 44),
            otherLocationButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}
