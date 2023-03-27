//
//  Project+Providable.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.
        

import Foundation
import UniformTypeIdentifiers

protocol Providable: Codable {
    associatedtype Wrapper: ProvidableWrapper where Wrapper.Item == Self
}

protocol ProvidableWrapper: AnyObject, NSObjectProtocol, NSItemProviderWriting, NSItemProviderReading {
    associatedtype Item: Providable where Item.Wrapper == Self
    
    var item: Item { get }
    init(_ : Item)
    
    static var uti: UTType { get }
    static var name: String { get }
    static var writableTypes: [UTType] { get }
    static var readableTypes: [UTType] { get }
}

extension Providable {
    var provider: NSItemProvider {
        .init(object: Wrapper(self))
    }
    
    static func load(from provider: NSItemProvider, completionHandler: @escaping (Self?, Error?) -> Void) {
        provider.loadItem(Self.self, completionHandler: completionHandler)
    }
}

extension NSItemProvider {
    func loadItem<T: Providable>(_ itemType: T.Type, completionHandler: @escaping (T?, Error?) -> Void) {
        if canLoadObject(ofClass: T.Wrapper.self) {
            _ = loadObject(ofClass: T.Wrapper.self) { wrapper, error in
                if let error = error {
                    completionHandler(nil, error)
                    return
                }
                
                if let wrapper = wrapper as? T.Wrapper {
                    completionHandler(wrapper.item, nil)
                    return
                } else {
                    completionHandler(nil, DecodingError.typeMismatch(T.Wrapper.self, .init(codingPath: [], debugDescription: "")))
                }
            }
        }
    }
}

extension [NSItemProvider] {
    func loadItems<T: Providable>(_ itemType: T.Type, completionHandler: @escaping (T?, Error?) -> Void) {
        forEach { provider in
            provider.loadItem(itemType, completionHandler: completionHandler)
        }
    }
}

enum ProvidableError: Error {
    case unsupportedUTIIdentifier
}

extension Project: Providable {
    final class Wrapper: NSObject, ProvidableWrapper {
        typealias Item = Project
        
        let item: Item
        
        required init(_ item: Item) {
            self.item = item
            super.init()
        }
        
        static var name: String = "project"
        
        static var uti: UTType = UTType("com.minii.projectmanager.project") ?? .data
        
        static var writableTypes: [UTType] {
            [uti]
        }
        
        static var readableTypes: [UTType] {
            [uti, UTType.plainText]
        }
        
        static var writableTypeIdentifiersForItemProvider: [String] {
            writableTypes.map(\.identifier)
        }
        
        static var readableTypeIdentifiersForItemProvider: [String] {
            readableTypes.map(\.identifier)
        }
        
        func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, Error?) -> Void) -> Progress? {
            do {
                switch typeIdentifier {
                case Self.uti.identifier:
                    let data = try JSONEncoder().encode(item)
                    completionHandler(data, nil)
                    
                default:
                    throw ProvidableError.unsupportedUTIIdentifier
                }
            } catch {
                completionHandler(nil, error)
            }
            
            return Progress(totalUnitCount: 100)
        }
        
        static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
            switch typeIdentifier {
            case Self.uti.identifier:
                let item = try JSONDecoder().decode(Item.self, from: data)
                
                return .init(item)
                
            case UTType.plainText.identifier:
                let title = String(decoding: data, as: UTF8.self)
                let item = Project(title: title, date: Date(), description: "")
                
                return .init(item)
                
            default:
                throw ProvidableError.unsupportedUTIIdentifier
            }
        }
        
        
    }
}
