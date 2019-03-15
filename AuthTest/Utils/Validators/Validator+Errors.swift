//
//  Validator+Errors.swift
//  AuthTest
//
//  Created by Ekaterina Nesterova on 14/03/2019.
//  Copyright © 2019 Ekaterina Nesterova. All rights reserved.
//

import Foundation
extension Validator {
    enum Errors: Error, LocalizedError {
        case emailIsEmpty
        case emailDoesNotMatchMask
        case passwordIsEmpty
        case passwordDoesNotMatchMask

        var errorDescription: String? {
            switch self {
            case .emailIsEmpty:
                return "Пустой email"
            case .emailDoesNotMatchMask:
                return "Некорректный email"
            case .passwordIsEmpty:
                return "Пустой пароль"
            case .passwordDoesNotMatchMask:
                return "Некорректный пароль"
            }
        }
    }
}
