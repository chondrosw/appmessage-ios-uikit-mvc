//
//  DatabaseManager.swift
//  AppMessage
//
//  Created by Chondro Satrio Wibowo on 16/02/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func userExists(with email:String,completion:@escaping((Bool)->Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        self.database.child(safeEmail).observeSingleEvent(of: .value, with: {
            snapshot in
            guard  snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func register(data user:ChatAppUser){
        database.child(user.safeEmail).setValue([
            "fullname":user.fullname,
            "email":user.emailAddress,
            "password":user.password,
            "avatar":user.profilePictureUrl
        ])
    }
}
