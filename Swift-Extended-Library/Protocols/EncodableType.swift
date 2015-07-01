//
//  EncodableType.swift
//  Swift-Extended-Library
//
//  Created by Manfred Lau on 1/30/15.
//
//

protocol EncodableType {
    init(decoder: Coder)
    func encodeWithCoder(encoder: Coder)
}

protocol SecureEncodableType {
    static var supportsSecureCoding: Bool { get }
}