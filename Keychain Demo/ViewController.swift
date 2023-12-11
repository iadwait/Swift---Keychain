//
//  ViewController.swift
//  Keychain Demo
//
//  Created by Adwait Barkale on 07/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        testDelete()
//        testSave()
//        testGet()
//        testUpdate()
    }
    
    func testSave() {
        do {
            try KeychainManager.save(key: "Name",
                                     value: "Adwait Barkale")
        } catch let err {
            print("Catch Error = \(err)")
        }
    }
    
    func testGet() {
        do {
            guard let strData = try KeychainManager.get(key: "Name") else {
                print("Failed to retrive data from keychain")
                return
            }
            
            print("Valued Fetched = \(strData)")
        } catch let err {
            print("Catch Error = \(err)")
        }
                    
    }
    
    func testUpdate() {
        do {
            try KeychainManager.update(key: "Name",
                                     value: "Adwait Barkale")
        } catch let err {
            print("Catch Error = \(err)")
        }
    }
    
    func testDelete() {
        do {
            try KeychainManager.delete(key: "Name")
        } catch let err {
            print("Catch Error = \(err)")
        }
    }
}

enum KeychainError: Error {
    case duplicateEntry
    case unknownError(OSStatus)
}

class KeychainManager {
    
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
            print("Keychain: Value for Key '\(key)' updated to '\(value)'")
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
    
    static func update(key: String,
                     value: String) throws {
        
        let valData = value.data(using: .utf8) ?? Data()
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key as AnyObject,
            kSecValueData as String: valData as AnyObject
        ]
        
        let status = SecItemUpdate(query as CFDictionary, NSDictionary(dictionary: [kSecValueData: valData]))
        print("Status = \(status)")
        
        guard status == errSecSuccess else {
            throw KeychainError.unknownError(status)
        }
        
        print("Updated: \(status)")
        
    }
    
    static func delete(key: String) throws {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key as AnyObject
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unknownError(status) }
        print("Deleted: \(errSecItemNotFound)")
    }
    
}
