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
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
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
    
    func configure(with model: TemperatureUIModel) {
        self.locationLabel.text = model.location
        self.temperatureLabel.text = model.temperature
        self.hTemperatureLabel.text = model.highTemperature
        self.lTemperatureLabel.text = model.lowTemperature
        self.weatherConditionsLabel.text = model.weatherDescription
    }
    
    private func setupViews() {
        [hTemperatureLabel, lTemperatureLabel].forEach { temperatureStackView.addArrangedSubview($0) }
        [weatherConditionsLabel, temperatureStackView].forEach { weatherConditionsStackView.addArrangedSubview($0) }
        [locationLabel, temperatureLabel, weatherConditionsStackView].forEach { verticalStackView.addArrangedSubview($0) }
        
        addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let sidePadding: CGFloat = 20 // Отступ с боков
        
        NSLayoutConstraint.activate([
               verticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
               verticalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
               verticalStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: sidePadding),
               verticalStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -sidePadding),
               verticalStackView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 2 * sidePadding)
           ])
    }
}
