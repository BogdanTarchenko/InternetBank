import Foundation

enum LoginValidationError: Error {
    case loginEmpty
    case loginInvalidFormat
    case loginNotLatin
    case passwordEmpty
    case passwordTooShort(minLength: Int)
    case passwordNotLatin

    var message: String { messageText }
}

enum LoginValidator {
    static func validate(login: String, password: String) -> [LoginValidationError] {
        var errors: [LoginValidationError] = []
        let loginTrimmed = login.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordTrimmed = password.trimmingCharacters(in: .whitespacesAndNewlines)

        if loginTrimmed.isEmpty {
            errors.append(.loginEmpty)
        } else {
            if !loginTrimmed.unicodeScalars.allSatisfy({ Validation.latinAndEmailAllowed.contains($0) }) {
                errors.append(.loginNotLatin)
            }
            if !Validation.emailPredicate.evaluate(with: loginTrimmed) {
                errors.append(.loginInvalidFormat)
            }
        }

        if passwordTrimmed.isEmpty {
            errors.append(.passwordEmpty)
        } else {
            if passwordTrimmed.count < Validation.minPasswordLength {
                errors.append(.passwordTooShort(minLength: Validation.minPasswordLength))
            }
            if !passwordTrimmed.unicodeScalars.allSatisfy({ Validation.latinAndPasswordAllowed.contains($0) }) {
                errors.append(.passwordNotLatin)
            }
        }

        return errors
    }
}

private extension LoginValidationError {
    var messageText: String {
        switch self {
        case .loginEmpty:
            return "Введите email"
        case .loginInvalidFormat:
            return "Некорректный email"
        case .loginNotLatin:
            return "Только латиница и @.-_"
        case .passwordEmpty:
            return "Введите пароль"
        case .passwordTooShort(let min):
            return "Пароль от \(min) символов"
        case .passwordNotLatin:
            return "Только латиница и цифры"
        }
    }
}

private extension LoginValidator {
    enum Validation {
        static let minPasswordLength = 8
        static let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        static let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        static let latinAndEmailAllowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@._%-+")
        static let latinAndPasswordAllowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:',.<>?/`~")
    }
}
