import UIKit

enum CellIconType: CaseIterable {
    case feelsLike
    case sunInfo
    case humidity
    case wind

    var icon: UIImage? {
        switch self {
        case .feelsLike:
            return UIImage.feelsLikeIcon
        case .sunInfo:
            return UIImage.sunInfoIcon
        case .humidity:
            return UIImage.humidityIcon
        case .wind:
            return UIImage.windIcon
        }
    }
}
