# Keychain Helper

## How you can use Keychain Database into your project ?
- Drag and drop "KeychainHelper" Folder into your Project from this Repository and you are done.

## Which operations are available and how you can use them ?
- All Basic operations are available like:-
  
  - Add Item to Keychain (Incase Item is already present in keychain update query is written in code)
  - Fetch value from Keychain
  - Update Value in Keychain
  - Delete Item in Keychain
 
- You can refer ViewController Class where all functions usage are given.

## Code Snippet ?
### Add Item to Keychain
```
    /// Function to save value in Keychain
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
```
### Fetch Value from Keychain
```
/// Function to fetch value in Keychain
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
```
### Update Value in Keychain
```
/// Function to Update Value in Keychain
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
```
### Delete Item in Keychain
```
/// Function to delete item in keychain
    /// - Parameter forKey: Key Name
    func deleteItemInKeychain(forKey: String) {
        do {
            try KeychainManager.delete(key: forKey)
        } catch let err {
            print("Catch Error = \(err)")
        }
    }
```
