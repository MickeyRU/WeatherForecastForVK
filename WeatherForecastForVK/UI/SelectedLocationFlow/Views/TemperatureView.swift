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
        label.textAlignment = .right
        return label
    }()
    
    private let lTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold20
        label.textColor = .primaryWhiteBlack
        label.textAlignment = .left
        return label
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
        [locationLabel, temperatureLabel, weatherConditionsLabel, hTemperatureLabel, lTemperatureLabel].forEach { addSubview($0) }
        [locationLabel, temperatureLabel, weatherConditionsLabel, hTemperatureLabel, lTemperatureLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let sidePadding: CGFloat = 20 // Отступ с боков
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: topAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sidePadding),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sidePadding),
            
            temperatureLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sidePadding),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sidePadding),
            
            weatherConditionsLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
            weatherConditionsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sidePadding),
            weatherConditionsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sidePadding),
            
            hTemperatureLabel.topAnchor.constraint(equalTo: weatherConditionsLabel.bottomAnchor),
            hTemperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sidePadding),
            hTemperatureLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.40),
            
            lTemperatureLabel.topAnchor.constraint(equalTo: weatherConditionsLabel.bottomAnchor),
            lTemperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sidePadding),
            lTemperatureLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.40)
        ])
    }
}
