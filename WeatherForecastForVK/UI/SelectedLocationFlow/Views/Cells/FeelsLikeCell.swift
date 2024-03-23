import UIKit

final class FeelsLikeCell: UICollectionViewCell, ConfigurableCell {
    typealias Model = FeelsLikeUIModel
    
    static var reuseIdentifier: String {
        return "FeelsLikeCell"
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        layer.cornerRadius = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: FeelsLikeUIModel) {}
}
