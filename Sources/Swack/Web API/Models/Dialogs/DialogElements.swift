//
//  DialogElements.swift
//  App
//
//  Created by franz busch on 04.07.18.
//

import Vapor

public enum DialogElementType: String, Codable {
    case text
    case textArea
    case select
}

public protocol DialogElement: Encodable {
    static var type: DialogElementType { get }

    var name: String { get }

    var onValidation: (() -> ValidationError)? { get }
}

public struct AnyDialogElement: Encodable {

    let base: DialogElement

    private enum CodingKeys: CodingKey {
        case base
    }

    init(_ base: DialogElement) {
        self.base = base
    }

    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }

}

public struct TextDialogElement: DialogElement {

    public static var type: DialogElementType = .text

    public enum Subtype: String, Encodable {
        case email
        case number
        case tel
        case url
    }

    public let label: String
    public let name: String
    public let type: String = "text"
    public let subtype: Subtype?
    public let maxLength: Int?
    public let minLength: Int?
    public let optional: Bool?
    public let hint: String?
    public let value: String?
    public let placeholder: String?

    public var onValidation: (() -> ValidationError)?

    enum CodingKeys: String, CodingKey {
        case label
        case name
        case type
        case subtype
        case maxLength = "max_length"
        case minLength = "min_length"
        case optional
        case hint
        case value
        case placeholder
    }

    public init(label: String, name: String, subtype: Subtype? = nil, maxLength: Int? = nil,
                minLength: Int? = nil, optional: Bool? = nil, hint: String? = nil,
                value: String? = nil, placeholder: String? = nil, onValidation: (() -> ValidationError)? = nil) {
        self.label = label
        self.name = name
        self.subtype = subtype
        self.maxLength = maxLength
        self.minLength = minLength
        self.optional = optional
        self.hint = hint
        self.value = value
        self.placeholder = placeholder
        self.onValidation = onValidation
    }

}

public struct TextAreaDialogElement: DialogElement {

    public static var type: DialogElementType = .textArea

    public enum Subtype: String, Encodable {
        case email
        case number
        case tel
        case url
    }

    public let label: String
    public let name: String
    public let type: String = "textarea"
    public let subtype: Subtype?
    public let maxLength: Int?
    public let minLength: Int?
    public let optional: Bool?
    public let hint: String?
    public let value: String?
    public let placeholder: String?

    public var onValidation: (() -> ValidationError)?

    enum CodingKeys: String, CodingKey {
        case label
        case name
        case type
        case subtype
        case maxLength = "max_length"
        case minLength = "min_length"
        case optional
        case hint
        case value
        case placeholder
    }

    public init(label: String, name: String, subtype: Subtype? = nil, maxLength: Int? = nil,
                minLength: Int? = nil, optional: Bool? = nil, hint: String? = nil,
                value: String? = nil, placeholder: String? = nil, onValidation: (() -> ValidationError)? = nil) {
        self.label = label
        self.name = name
        self.subtype = subtype
        self.maxLength = maxLength
        self.minLength = minLength
        self.optional = optional
        self.hint = hint
        self.value = value
        self.placeholder = placeholder
        self.onValidation = onValidation
    }

}

public struct SelectDialogElementOption: Encodable {

    public let label: String
    public let value: String

    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }

}

public struct SelectDialogElement: DialogElement {

    public static var type: DialogElementType = .select

    public let label: String
    public let name: String
    public let type: String = "select"
    public let placeholder: String?
    public let optional: Bool?
    public let value: String?
    public let options: [SelectDialogElementOption]

    public var onValidation: (() -> ValidationError)?

    enum CodingKeys: String, CodingKey {
        case label
        case name
        case type
        case placeholder
        case optional
        case value
        case options
    }

    public init(label: String, name: String, placeholder: String? = nil, optional: Bool? = nil, value: String? = nil, options: [SelectDialogElementOption], onValidation: (() -> ValidationError)? = nil) {
        self.label = label
        self.name = name
        self.placeholder = placeholder
        self.optional = optional
        self.value = value
        self.options = options
        self.onValidation = onValidation
    }

}
