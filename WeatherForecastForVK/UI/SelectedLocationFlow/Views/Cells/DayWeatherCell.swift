import UIKit

final class DayWeatherCell: UICollectionViewCell {
    static let reuseIdentifier = "DayWeatherCell"
    
    private let dayNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold15
        label.textColor = .primaryWhiteBlack
        label.textAlignment = .center
        return label
    }()
    
    private let dayTempLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular20
        label.textColor = .primaryWhiteBlack
        label.textAlignment = .center
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: DayWeatherUIModel) {
        self.dayNameLabel.text = model.dayOfWeek
        self.dayTempLabel.text = model.averageTemperature
        self.weatherImageView.image = UIImage(named: model.weatherIconName)
    }
    
    private func setupViews() {
        backgroundColor = .dayCellbg.withAlphaComponent(0.5)
        layer.cornerRadius = 30
        layer.borderWidth = 1
        layer.borderColor = UIColor.brd.cgColor
        
        [dayNameLabel, dayTempLabel, weatherImageView].forEach { contentView.addSubview($0) }
        [dayNameLabel, dayTempLabel, weatherImageView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            dayNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dayNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dayNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            weatherImageView.topAnchor.constraint(equalTo: dayNameLabel.bottomAnchor, constant: 16),
            weatherImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 35),
            weatherImageView.heightAnchor.constraint(equalToConstant: 35),
            
            dayTempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            dayTempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dayTempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
    }
}
