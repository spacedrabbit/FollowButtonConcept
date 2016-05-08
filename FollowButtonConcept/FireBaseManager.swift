//
//  FireBaseManager.swift
//  FollowButtonConcept
//
//  Created by Louis Tur on 5/7/16.
//  Copyright © 2016 SRLabs. All rights reserved.
//

import Foundation
import Firebase

internal struct Paths {
  internal static let BaseURL: String = "https://posse-finder.firebaseIO.com"
  internal static let DataNode: String = "/data"
  internal static let UsersNode: String = "/user"
}

internal struct Keys {
  internal static let UserName: String = "username"
  internal static let FirstName: String = "first_name"
  internal static let LastName: String = "last_name"
  internal static let Nickname: String = "nickname"
  internal static let Email: String = "email"
  internal static let Followers: String = "followers"
  internal static let Following: String = "following"
}

internal class FireBaseManager {
  
  private static let secretKey: String = "O1iGcue54dWomFn0Rwc0DopBDlF2xzBZpbi27JdI"
  private static let firebaseURL: String = "https://posse-finder.firebaseIO.com"
  private var firebaseReference: Firebase!
  
  // singleton manager
  internal static let sharedManager: FireBaseManager = FireBaseManager(withURL: FireBaseManager.firebaseURL)
  private init(withURL url: String) {
    self.firebaseReference = Firebase(url: url)
  }
  
  internal func createTestUsers() {
    
    let testUserFirst: String = "Louis" + "\(randomInt())"
    let testUserLast: String = "Tur" + "\(randomInt())"
    let testUsername: String = testUserFirst + testUserLast
    
    let newUser: [String : AnyObject] = [
      testUsername : [
        Keys.FirstName : testUserFirst,
        Keys.LastName : testUserLast
      ]
    ]
    
    let userRef = self.firebaseReference.childByAppendingPath(Paths.DataNode + Paths.UsersNode)
    //    userRef.setValue(newUser) // completely overwrites the /data/user node with new value
    userRef.updateChildValues(newUser) // updates the /data/user note by adding a new value
  }
  
  internal func newUser(user user: PosseUser, completion: (success: Bool)->Void) {
    let ref = FireBaseManager.sharedManager.firebaseReference
    
    ref.createUser(user.emailAddress, password: "posse",
      withValueCompletionBlock: { (error: NSError?, result: [NSObject : AnyObject]?) in
        
        if error != nil {
          print("Error encountered on creating a user account: \(error!.description)")
          completion(success: false)
        } else {
          let uid: String? = result?["uid"] as? String
          print("Successfully created user account with uid: \(uid)")
          completion(success: true)
        }
    })
  }
  
  internal func loginUser(email: String, password: String, completion: (success: Bool) -> Void) {
    let ref = FireBaseManager.sharedManager.firebaseReference
    ref.authUser(email, password: password,
      withCompletionBlock: { (error: NSError?, authData: FAuthData?) in
        
        if error != nil {
          print("Error encountered on logging in: \(error!.description)")
          completion(success: false)
        } else {
          print("User has been logged in successfully")
          completion(success: true)
        }
    })
  }
  
  internal func updateUser(user: PosseUser) {
    let userRef = self.firebaseReference.childByAppendingPath(Paths.DataNode + Paths.UsersNode + "/" + user.username)
    let updateJson: [String : AnyObject] = user.toJson()
    
    userRef.updateChildValues(updateJson) { (error: NSError?, fireBaseRef: Firebase!) -> Void in
      if error != nil {
        print("Error encountered on user update: \(error!.description)")
      }
      else {
        print("User updated")
      }
    
    }
  }
  
  internal func deleteUser(user: PosseUser) {
    let ref = FireBaseManager.sharedManager.firebaseReference
    
    ref.removeUser(user.emailAddress, password: "posse",
      withCompletionBlock: { error in
        
        if error != nil {
          print("Error encountered on deleting a user: \(error!.description)")
        } else {
          print("User successfully deleted")
        }
    })
  }
  
  private func randomInt() -> UInt32 {
    return arc4random_uniform(UInt32.max)
  }
}
