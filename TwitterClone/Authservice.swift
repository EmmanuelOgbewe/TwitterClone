//
//  Authservice.swift
//  TwitterClone
//
//  Created by Emmanuel  Ogbewe on 12/29/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

public class AuthService {
    
    //Sign Up user
    static private let db = Firestore.firestore()
    
    static func signUp (username: String, password: String, email:String, profileImgUrl : String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if(err != nil){
                onError(err!.localizedDescription)
            }
            guard let user = result?.user else { return }
            AuthService.setUserInfo(uid: user.uid, username: username.lowercased(), password: password,  email: email, profileImgUrl: profileImgUrl, onSuccess: {
                onSuccess()
            })
        }
        
    }
    //Sign In user
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
    // Logout User
    static func logout(onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
            
        } catch let logoutError {
            onError(logoutError.localizedDescription)
        }
    }
    //Set User information
    static func setUserInfo(uid: String, username: String, password: String, email:String, profileImgUrl : String, onSuccess: @escaping () -> Void){
        let data : [String: Any] = ["id": uid, "username": username, "email": email,"profileImgUrl":profileImgUrl]
        db.collection("users").document(uid).setData(data, completion: { (err) in
            if(err != nil){
                print(err!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
}
