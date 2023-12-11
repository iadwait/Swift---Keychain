//
//  KeychainManager.swift
//  Keychain Demo
//
//  Created by Adwait Barkale on 11/12/23.
//

import Foundation

/// Enum to decide Keychain Errors
enum KeychainError: Error {
    case duplicateEntry
    case unknownError(OSStatus)
}

/// Class to do Keychain related operations like Save, Update, Delete, Fetch
class KeychainManager {
    
    /// Function call to save item in keychain, Note: - Code written will update value incase entry already present
    /// - Parameters:
    ///   - key: Key
    ///   - value: Value
    static func save(key: String,
                     value: String) throws {
        // Service, Account, Class, Data (Item to be saved)
        // Service, Account, Class are unique elements used to identify item in the keychain
        
        let valData = value.data(using: .utf8) ?? Data()
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key as AnyObject,
            kSecValueData as String: valData as AnyObject
        ]
        
        // Check if Item is already Available, if yes we will perform Update
        if SecItemCopyMatching(query as CFDictionary, nil) == noErr {
            let status = SecItemUpdate(query as CFDictionary, NSDictionary(dictionary: [kSecValueData: valData]))
            guard status == errSecSuccess else {
                throw KeychainError.unknownError(status)
            }
            print("Keychain: Key '\(key)' is already present, Value Updated to '\(value)'")
        } else {
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status != errSecDuplicateItem else {
                throw KeychainError.duplicateEntry
            }
            guard status == errSecSuccess else {
                throw KeychainError.unknownError(status)
            }
            print("Keychain: New Entry Added with key '\(key) and value: '\(value)'")
        }
        
    }
    
    /// Function call to Fetch value from Keychain
    /// - Parameter key: Key Name
    /// - Returns: Value
    static func get(key: String) throws -> String? {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne // Exactly one match
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknownError(status)
        }
        
        if let safeData = result as? Data {
            let strValue = String(data: safeData, encoding: .utf8) ?? ""
            print("Keychain: Value fetched '\(strValue)' for key '\(key)'")
            return strValue
        }
        return ""
        
    }
    
    /// Function call to update values in keychain
    /// - Parameters:
    ///   - key: Key
    ///   - value: Value
    static func update(key: String,
                     value: String) throws {
        
        let valData = value.data(using: .utf8) ?? Data()
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key as AnyObject,
            kSecValueData as String: valData as AnyObject
        ]
        
        let status = SecItemUpdate(query as CFDictionary, NSDictionary(dictionary: [kSecValueData: valData]))
        
        guard status == errSecSuccess else {
            throw KeychainError.unknownError(status)
        }
        
        print("Keychain: Value updated to '\(value)' for key '\(key)'")
        
    }
    
    /// Function call to delete entry in keychain
    /// - Parameter key: Key
    static func delete(key: String) throws {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key as AnyObject
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unknownError(status) }
        print("Keychain: Item has been deleted successfully !!")
    }
    
}
