//
//  PosseUser.swift
//  FollowButtonConcept
//
//  Created by Louis Tur on 5/8/16.
//  Copyright © 2016 SRLabs. All rights reserved.
//

import Foundation

internal protocol Jsonable: class {
  func toJson() -> [String : AnyObject]
}

internal class PosseUser: Jsonable {
  
  internal var firstName: String!
  internal var lastName: String!
  internal var emailAddress: String!
  internal var username: String!
  internal var profileImageURL: String?
  
  internal var followers: [String] = []
  internal var following: [String] = []
  internal var posts: [String] = []
  
  internal init(firstName: String, lastName: String, emailAddress: String, username: String, imageURL: String) {
    self.firstName = firstName
    self.lastName = lastName
    self.emailAddress = emailAddress
    self.username = username
    self.profileImageURL = imageURL
  }
  
  internal func updateUser(username: String, firstName: String?, lastName: String?, emailAddress: String?) {
    self.firstName = firstName ?? self.firstName
    self.lastName = lastName ?? self.lastName
    self.emailAddress = emailAddress ?? self.emailAddress
    
    FireBaseManager.sharedManager.updateUser(self)
  }
  
  // MARK: Jsonable Protocol
  internal func toJson() -> [String : AnyObject] {
    return [
      Keys.UserName : [
        Keys.FirstName : self.firstName,
        Keys.LastName : self.lastName,
        Keys.Email : self.emailAddress,
        Keys.Nickname : self.username,
        Keys.Following : self.following,
        Keys.Followers : self.followers,
      ]
    ]
  }
  
  internal func userFollows(user: PosseUser) -> Bool {
    
    var follows: Bool = false
    self.following.forEach { (currentFollowing: String) -> () in
      if currentFollowing == user.username {
        follows = true
      }
    }
    
    return follows
  }
  
  internal func followUser(user: PosseUser) {
    if !self.userFollows(user) {
      self.following.append(user.username)
    }
  }
  
}