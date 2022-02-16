//
//  ChatAppUser.swift
//  AppMessage
//
//  Created by Chondro Satrio Wibowo on 16/02/22.
//

import Foundation

struct ChatAppUser{
    let fullname:String
    let emailAddress:String
    let password:String
    let profilePictureUrl:String
    
    var safeEmail:String{
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
