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
  
  internal func updateSpecificTestUser(user: String) {
    let userRef = self.firebaseReference.childByAppendingPath(Paths.DataNode + Paths.UsersNode + "/" + user)
    let testUserNick: String = "Eagle" + "\(randomInt())"
    userRef.updateChildValues([Keys.Nickname : testUserNick])
  }
  
  internal func writeKey(key: String, value: String) {
//    self.firebaseReference.setVa
  }
  
  private func randomInt() -> UInt32 {
    return arc4random_uniform(UInt32.max)
  }
}
