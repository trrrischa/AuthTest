//
//  ValidatorProtocol.swift
//  AuthTest
//
//  Created by Ekaterina Nesterova on 14/03/2019.
//  Copyright © 2019 Ekaterina Nesterova. All rights reserved.
//

import Foundation

protocol ValidatorProtocol: class {
    func checkEmail(email: String) throws
    func checkPassword(password: String) throws 
}
