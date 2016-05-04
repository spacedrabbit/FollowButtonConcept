//
//  ViewController.swift
//  FollowButtonConcept
//
//  Created by Louis Tur on 5/3/16.
//  Copyright © 2016 SRLabs. All rights reserved.
//

import UIKit
import SnapKit

internal struct ConceptColors {
  static let LightBlue: UIColor = UIColor(colorLiteralRed: 130.0/255.0, green: 222.0/255.0, blue: 255.0/255.0, alpha: 1.0)
  static let MediumBlue: UIColor = UIColor(colorLiteralRed: 113.0/255.0, green: 156.0/255.0, blue: 255.0/255.0, alpha: 1.0)
  static let OffWhite: UIColor = UIColor(colorLiteralRed: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
  static let DarkText: UIColor = UIColor(colorLiteralRed: 100.0/255.0, green: 100.0/255.0, blue: 150.0/255.0, alpha: 1.0)
}

class ProfileViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.grayColor()
    
    self.setupViewHierarchy()
    self.configureConstraints()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.followButton.updateCornerRadius()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  internal func configureConstraints() {
    self.profileBackgroundView.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(self.view).offset(60.0)
      make.left.equalTo(self.view).offset(22.0)
      make.right.equalTo(self.view).inset(22.0)
      make.bottom.equalTo(self.view).inset(60.0)
    }
    
    self.profileBottomSectionView.snp_makeConstraints { (make) -> Void in
      make.left.right.bottom.equalTo(self.profileBackgroundView)
      make.top.equalTo(self.profileBackgroundView.snp_centerY).multipliedBy(1.30)
    }
    
    self.followButton.snp_makeConstraints { (make) -> Void in
      make.centerY.equalTo(self.profileBottomSectionView.snp_top)
      make.centerX.equalTo(self.profileBottomSectionView)
      make.height.width.greaterThanOrEqualTo(0.0).priority(990.0)
    }
  }
  
  internal func setupViewHierarchy() {
    self.view.addSubview(profileBackgroundView)
    self.profileBackgroundView.addSubview(self.profileBottomSectionView)
    self.profileBackgroundView.addSubview(self.followButton)
  }
  
  lazy var profileBackgroundView: UIView = {
    let view: UIView = UIView()
    view.backgroundColor = ConceptColors.LightBlue
    view.layer.cornerRadius = 12.0
    view.clipsToBounds = true
    return view
  }()
  
  lazy var profileTopSectionView: UIView = {
    let view: UIView = UIView()
    return view
  }()
  
  lazy var profileBottomSectionView: UIView = {
    let view: UIView = UIView()
    view.backgroundColor = ConceptColors.OffWhite
    return view
  }()
  
  lazy var followButton: FollowButton = FollowButton()
  
}

internal class FollowButton: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setupViewHierarchy()
    self.configureConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  internal func updateCornerRadius() {
    self.layoutIfNeeded()
    
    let currentHeight: CGFloat = self.frame.size.height
    self.buttonView.layer.cornerRadius = currentHeight/2.0
  }
  
  internal func configureConstraints() {
    self.buttonView.snp_makeConstraints { (make) -> Void in
      make.top.bottom.centerX.equalTo(self)
      make.left.greaterThanOrEqualTo(self)
      make.right.lessThanOrEqualTo(self)
    }
    
    self.buttonLabel.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(buttonView).offset(14.0)
      make.bottom.equalTo(buttonView).inset(14.0)
      make.right.equalTo(buttonView).inset(36.0)
      make.left.equalTo(buttonView).offset(36.0)
    }
  }
  
  internal func setupViewHierarchy() {
    self.addSubview(buttonView)
    self.buttonView.addSubview(buttonLabel)
  }
  
  lazy var buttonView: UIView = {
    let view: UIView = UIView()
    view.backgroundColor = UIColor.whiteColor()
    view.layer.cornerRadius = 15.0
    view.clipsToBounds = true
    return view
  }()
  
  internal lazy var buttonLabel: UILabel = {
    var label: UILabel = UILabel()
    label.textColor = ConceptColors.DarkText
    label.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightMedium)
    label.text = "F O L L O W"
    return label
  }()
}

