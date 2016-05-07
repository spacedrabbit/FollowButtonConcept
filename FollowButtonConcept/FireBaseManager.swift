//
//  FireBaseManager.swift
//  FollowButtonConcept
//
//  Created by Louis Tur on 5/7/16.
//  Copyright © 2016 SRLabs. All rights reserved.
//

import Foundation
import Firebase

internal class FireBaseManager {
  
  private static let secretKey: String = "O1iGcue54dWomFn0Rwc0DopBDlF2xzBZpbi27JdI"
  private static let firebaseURL: String = "https://posse-finder.firebaseIO.com"
  private var firebaseReference: Firebase!
  
  // singleton manager
  internal static let sharedManager: FireBaseManager = FireBaseManager(withURL: FireBaseManager.firebaseURL)
  private init(withURL url: String) {
    self.firebaseReference = Firebase(url: url)
  }
  
  internal func writeKey(key: String, value: String) {
//    self.firebaseReference.setVa
  }
}
