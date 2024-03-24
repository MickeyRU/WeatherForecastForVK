import UIKit

enum AppError: Error, Equatable {
    case networkError(String)
    case customError(String)
}

final class ErrorHandler {
    static func handle(error: AppError, handler: (() -> Void)? = nil) {
        print("Ошибка: \(error)")
        showAlert(title: NSLocalizedString("error", tableName: "ErrorHandler", comment: ""),
                  message: message(for: error),
                  handler: handler)
    }

    private static func message(for error: AppError) -> String {
        switch error {
        case .networkError:
            return NSLocalizedString("networkError", tableName: "ErrorHandler", comment: "")
        case .customError(let message):
            return message
        }
    }

    private static func showAlert(title: String, message: String, handler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                if let handler = handler {
                    handler()
                }
            }))

            UIViewController.topMostViewController()?.present(alert, animated: true)
        }
    }
}
