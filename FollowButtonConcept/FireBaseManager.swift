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
    
    let testUserFirst: String = "Louis" + "\(arc4random_uniform(UInt32.max))"
    let testUserLast: String = "Tur" + "\(arc4random_uniform(UInt32.max))"
    let testUsername: String = testUserFirst + testUserLast
    
    let newUser: [String : AnyObject] = [testUsername : [Keys.FirstName : testUserFirst, Keys.LastName : testUserLast]]
    
    let userRef = self.firebaseReference.childByAppendingPath(Paths.DataNode + Paths.UsersNode)
    userRef.setValue(newUser)
  }
  
  internal func writeKey(key: String, value: String) {
//    self.firebaseReference.setVa
  }
}
