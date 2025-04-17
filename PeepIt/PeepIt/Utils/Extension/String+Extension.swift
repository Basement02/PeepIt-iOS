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
            .union(CharacterSet(charactersIn: "\u{AC00}"..."\u{D7A3}"))
        
        return self.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }

    var isValidForWords: Bool {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
            .union(CharacterSet(charactersIn: "\u{AC00}"..."\u{D7A3}")) // 한글 범위 포함
        return self.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }

    var forceCharWrapping: Self {
        self.map({ String($0) }).joined(separator: "\u{200B}")
    }

    var phoneFormatted: String {
        guard self.count == 11 else { return self }

        let start = self.prefix(3)
        let middle = self.dropFirst(3).prefix(4)
        let end = self.suffix(4)

        return "\(start)-\(middle)-\(end)"
    }

    /// 문자열 끝 글자의 받침 유무에 따라 "을" 또는 "를" 반환
    var objectParticle: String {
        guard let last = self.last else { return "를" } // 빈 문자열 처리

        let scalar = last.unicodeScalars.first!.value
        let base: UInt32 = 0xAC00
        let lastInKorean: UInt32 = 0xD7A3

        // 한글 음절 여부 확인
        guard scalar >= base && scalar <= lastInKorean else {
            return "를"
        }

        // 받침 유무 판단: 종성 인덱스 = (유니코드 - base) % 28
        let hasFinalConsonant = ((scalar - base) % 28) != 0

        return hasFinalConsonant ? "을" : "를"
    }

    /// 문자열 뒤에 적절한 목적어 조사("을" 또는 "를")를 붙여 반환
    var withObjectParticle: String {
        return self + self.objectParticle
    }
}
