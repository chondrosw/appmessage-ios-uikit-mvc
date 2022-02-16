//
//  FirebaseAuthManager.swift
//  AppMessage
//
//  Created by Chondro Satrio Wibowo on 13/02/22.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager{
    
    func createAccountWith(email:String,password:String,completion:@escaping(_ success:Bool,_ message:String)->Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            authResult,error in
            print(authResult)
            if authResult != nil{
                completion(true,"Selamat User berhasil daftar")
            }else{
                print(error?.localizedDescription)
                completion(false,error!.localizedDescription)
            }
            
        })
    }
    
    func loginAccountWith(email:String,password:String,completion:@escaping(_ success:Bool,_ message:String)->Void){
        Auth.auth().signIn(withEmail: email, password: password, completion: {(result,error) in
            if result?.user != nil{
                completion(true,"User Berhasil Login")
            }else{
                completion(false,error!.localizedDescription)
            }
        })
    }
    
    func logoutAccount(){
        do{
            try FirebaseAuth.Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "logged_in")
            
        }catch  {
            
        }
        
    }
}
