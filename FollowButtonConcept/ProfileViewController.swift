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
    self.drawGradientIn(self.profileTopSectionView)
  }
  
  // MARK: - UI Updates
  // ------------------------------------------------------------
  internal func drawGradientIn(view: UIView) {
    self.view.layoutIfNeeded()
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [ConceptColors.LightBlue.CGColor, ConceptColors.MediumBlue.CGColor]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.startPoint = CGPointMake(0.0, 0.0)
    gradientLayer.endPoint = CGPointMake(1.0, 1.0)
    
    view.layer.addSublayer(gradientLayer)
  }
  
  
  // MARK: - Layout
  internal func configureConstraints() {
    self.profileBackgroundView.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(self.view).offset(60.0)
      make.left.equalTo(self.view).offset(22.0)
      make.right.equalTo(self.view).inset(22.0)
      make.bottom.equalTo(self.view).inset(60.0)
    }
    
    self.profileTopSectionView.snp_makeConstraints { (make) -> Void in
      make.top.left.right.equalTo(self.profileBackgroundView)
      make.bottom.equalTo(self.profileBottomSectionView.snp_top)
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
    self.profileBackgroundView.addSubview(self.profileTopSectionView)
    self.profileBackgroundView.addSubview(self.profileBottomSectionView)
    self.profileBackgroundView.addSubview(self.followButton)
  }
  
  
  // MARK: - Lazy Instances
  lazy var profileBackgroundView: UIView = {
    let view: UIView = UIView()
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

