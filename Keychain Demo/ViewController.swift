//
//  ViewController.swift
//  Keychain Demo
//
//  Created by Adwait Barkale on 07/12/23.
//

import UIKit

/// This class is controller for ViewController UI
class ViewController: UIViewController {
    
    // MARK: - View's Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        saveInKeychain(key: "Name", value: "Adwait")
        fetchValueFromKeychain(forKey: "Name")
        updateItemInKeychain(forKey: "Name", updatedValue: "Adwait Barkale")
        deleteItemInKeychain(forKey: "Name")
    }
    
    // MARK: - User Defined Methods
    
    /// Sample Function to save value in Keychain
    /// - Parameters:
    ///   - key: Key Name
    ///   - value: Value
    func saveInKeychain(key: String, value: String) {
        do {
            try KeychainManager.save(key: key,
                                     value: value)
        } catch let err {
            print("Catch Error = \(err)")
        }
    }
    
    /// Sample Function to fetch value in Keychain
    /// - Parameter forKey: Key Name
    func fetchValueFromKeychain(forKey: String) {
        do {
            guard let strData = try KeychainManager.get(key: forKey) else {
                print("Failed to retrive data from keychain")
                return
            }
            
            print("Valued Fetched = \(strData)")
        } catch let err {
            print("Catch Error = \(err)")
        }
                    
    }
    
    /// Sample Function to Update Value in Keychain
    /// - Parameters:
    ///   - forKey: Key Name
    ///   - updatedValue: Updated Value
    func updateItemInKeychain(forKey: String, updatedValue: String) {
        do {
            try KeychainManager.update(key: forKey,
                                     value: updatedValue)
        } catch let err {
            print("Catch Error = \(err)")
        }
    }
    
    /// Sample Function to delete item in keychain
    /// - Parameter forKey: Key Name
    func deleteItemInKeychain(forKey: String) {
        do {
            try KeychainManager.delete(key: forKey)
        } catch let err {
            print("Catch Error = \(err)")
        }
    }
    
}
