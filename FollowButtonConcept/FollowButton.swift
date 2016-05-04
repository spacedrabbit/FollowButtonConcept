//
//  FollowButton.swift
//  FollowButtonConcept
//
//  Created by Louis Tur on 5/3/16.
//  Copyright © 2016 SRLabs. All rights reserved.
//

import UIKit
import SnapKit

protocol FollowButtonDelegate: class {
  func handleFollowButtonPress(action: (()->Void))
}

internal class FollowButton: UIView {

  // MARK: - Variables
  // ------------------------------------------------------------
  internal var delegate: FollowButtonDelegate?
  private var loadingStateWidthConstraints: (left: Constraint?, right: Constraint?)
  private var normalStateWidthConstraint: (left: Constraint?, right: Constraint?)
  
  // MARK: - Initialization
  // ------------------------------------------------------------
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setupViewHierarchy()
    self.configureConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  
  // MARK: - Layout Setup
  // ------------------------------------------------------------
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
      let right: Constraint = make.right.equalTo(buttonView).inset(48.0).constraint
      let left: Constraint = make.left.equalTo(buttonView).offset(48.0).constraint
      self.loadingStateWidthConstraints = (left, right)
    }
  }
  
  internal func setupViewHierarchy() {
    self.addSubview(buttonView)
    self.buttonView.addSubview(buttonLabel)
  }
  
  
  // MARK: - Lazy Instances
  // ------------------------------------------------------------
  lazy var buttonView: UIControl = {
    let control: UIControl = UIControl()
    control.backgroundColor = UIColor.whiteColor()
    control.layer.cornerRadius = 15.0
    control.clipsToBounds = true
    
    control.addTarget(self, action: "followButtonTapped:", forControlEvents: [.TouchUpInside, .TouchUpOutside])
    control.addTarget(self, action: "followButtonHighlighted:", forControlEvents: [.TouchDown, .TouchDragEnter, .TouchDragInside])
    control.addTarget(self, action: "followButtonReleased:", forControlEvents: [.TouchCancel, .TouchDragExit, .TouchDragOutside])
    return control
  }()
  
  internal lazy var buttonLabel: UILabel = {
    var label: UILabel = UILabel()
    label.textColor = ConceptColors.DarkText
    label.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightMedium)
    label.text = "F O L L O W"
    return label
  }()
  
  
  // MARK: - Animations
  // ------------------------------------------------------------
  private func startButtonLoadingAnimation() {
    
    let currentHeight: CGFloat = self.frame.size.height
    self.loadingStateWidthConstraints.left?.deactivate()
    self.loadingStateWidthConstraints.right?.deactivate()
    
    self.buttonLabel.snp_makeConstraints { (make) -> Void in
      make.center.equalTo(self.buttonView).priorityRequired()
      self.loadingStateWidthConstraints.left = make.left.lessThanOrEqualTo(self.buttonView).constraint
      self.loadingStateWidthConstraints.right = make.right.greaterThanOrEqualTo(self.buttonView).constraint
    }
    
    self.buttonView.snp_remakeConstraints { (make) -> Void in
      make.edges.equalTo(self)
      make.width.height.equalTo(currentHeight)
    }
    
    UIView.animateKeyframesWithDuration(0.55, delay: 0.0, options: [.LayoutSubviews, .CalculationModePaced], animations: { () -> Void in
      self.buttonLabel.alpha = 1.0
      
      UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.2, animations: { () -> Void in
        self.buttonLabel.alpha = 0.0
      })
      
      self.layoutIfNeeded()
      }) { (complete: Bool) -> Void in
        if complete {
          
        }
    }
    
  }
  
  private func attachStretchAnimationToButton() {
    
  }
  
  // MARK: - Button Control Actions
  // ------------------------------------------------------------
  internal func followButtonTapped(sender: AnyObject?) {
    print("follow button tapped")
    self.buttonLabel.textColor = ConceptColors.DarkText
    
    // TODO: animation
    self.startButtonLoadingAnimation()
  }
  
  internal func followButtonHighlighted(sender: AnyObject?) {
    self.buttonLabel.textColor = ConceptColors.MediumBlue
  }
  
  internal func followButtonReleased(sender: AnyObject?) {
    self.buttonLabel.textColor = ConceptColors.DarkText
  }
  
}