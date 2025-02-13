//
//  String+Extension.swift
//  PeepIt
//
//  Created by 김민 on 11/4/24.
//

import Foundation

extension String {

    var isValidForAllowedCharacters: Bool {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-.")
        return self.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }

    var forceCharWrapping: Self {
        self.map({ String($0) }).joined(separator: "\u{200B}")
    }
}
