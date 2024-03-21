import UIKit

final class TemperatureView: UIView {
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular34
        label.textColor = .primaryWhiteBlack
        label.textAlignment = .center
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.thin96
        label.textColor = .primaryWhiteBlack
        label.textAlignment = .center
        return label
    }()
    
    private let weatherConditionsLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold20
        label.textColor = .secondaryGray
        label.textAlignment = .center
        return label
    }()
    
    private let hTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold20
        label.textColor = .primaryWhiteBlack
        label.textAlignment = .center
        return label
    }()
    
    private let lTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold20
        label.textColor = .primaryWhiteBlack
        label.textAlignment = .center
        return label
    }()
    
    private lazy var temperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var weatherConditionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(with model: SelectedLocationUIModel) {
        self.locationLabel.text = model.location
        self.temperatureLabel.text = model.temperature
        self.hTemperatureLabel.text = model.hTemperature
        self.lTemperatureLabel.text = model.lTemperature
        self.weatherConditionsLabel.text = model.weatherConditions
    }
    
    private func setupViews() {
        [locationLabel, temperatureLabel, weatherConditionsLabel].forEach { verticalStackView.addArrangedSubview($0) }
        [hTemperatureLabel, lTemperatureLabel].forEach { temperatureStackView.addArrangedSubview($0) }
        [temperatureStackView, weatherConditionsStackView].forEach { verticalStackView.addArrangedSubview($0) }
        
        addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
