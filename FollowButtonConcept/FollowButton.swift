//
//  FollowButton.swift
//  FollowButtonConcept
//
//  Created by Louis Tur on 5/3/16.
//  Copyright © 2016 SRLabs. All rights reserved.
//

import UIKit
import SnapKit

public protocol FollowButtonDelegate: class {
  func handleFollowButtonPress(action: (()->Void))
}

public class FollowButton: UIView {
  
  private enum FollowState {
    case NotFollowing
    case Following
  }

  
  // MARK: - Variables
  // ------------------------------------------------------------
  public var delegate: FollowButtonDelegate?
  private var currentState: FollowState = .NotFollowing
  private var loadingStateWidthConstraints: (left: Constraint?, right: Constraint?)
  
  
  // MARK: - Initialization
  // ------------------------------------------------------------
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setupViewHierarchy()
    self.configureConstraints()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  
  // MARK: - Layout Setup
  // ------------------------------------------------------------
  // TODO: I dont like that I need to call this from the sender's viewWillAppear, figure out how to do this internally
  internal func updateCornerRadius() {
    self.layoutIfNeeded()
    
    let currentHeight: CGFloat = self.frame.size.height
    self.buttonView.layer.cornerRadius = currentHeight/2.0
  }
  
  private func configureConstraints() {
    self.buttonView.snp_makeConstraints { (make) -> Void in
      make.top.bottom.centerX.equalTo(self)
      make.left.greaterThanOrEqualTo(self)
      make.right.lessThanOrEqualTo(self)
    }
    
    self.buttonLabel.snp_makeConstraints { (make) -> Void in
      // pads the top and bottom of the label by expanding the superview
      make.top.equalTo(buttonView).offset(14.0)
      make.bottom.equalTo(buttonView).inset(14.0)
      make.center.equalTo(buttonView).priorityRequired()
      
      self.loadingStateWidthConstraints.right = make.right.equalTo(buttonView).inset(48.0).constraint
      self.loadingStateWidthConstraints.left = make.left.equalTo(buttonView).offset(48.0).constraint
    }
    
    self.spinnerImageView.snp_makeConstraints { (make) -> Void in
      make.center.equalTo(self.buttonView)
      make.height.width.equalTo(36.0)
    }
  }
  
  private func setupViewHierarchy() {
    self.addSubview(buttonView)
    self.buttonView.addSubview(buttonLabel)
    self.buttonView.addSubview(spinnerImageView)
  }
  
  /** Used to update the UI state of the button and label
   */
  private func updateButtonToState(state: FollowState) {
    switch state {
    case .NotFollowing:
      self.buttonLabel.text = "F O L L O W"
      self.buttonView.backgroundColor = ConceptColors.OffWhite
      self.buttonLabel.textColor = ConceptColors.DarkText
      
    case .Following:
      self.buttonLabel.text = "F O L L O W I N G"
      self.buttonView.backgroundColor = ConceptColors.MediumBlue
      self.buttonLabel.textColor = ConceptColors.OffWhite
    }
  }
  
  // MARK: - Lazy Instances
  // ------------------------------------------------------------
  internal lazy var buttonView: UIControl = {
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
  
  internal lazy var spinnerImageView: UIImageView = {
    let imageView: UIImageView = UIImageView(image: UIImage(named: "squareSpinner"))
    imageView.contentMode = .ScaleAspectFit
    imageView.alpha = 0.0
    return imageView
  }()
  
  
  // MARK: - Animations
  // ------------------------------------------------------------
  public func setLoadingState(isLoading: Bool) {
    if isLoading {
      self.attachRotationAnimationToSpinner()
    }
    else {
      self.stopAnimatingSpinner()
    }
  }
  
  private func stopAnimatingSpinner() {
    self.spinnerImageView.layer.removeAllAnimations()
  }
  
  private func startButtonLoadingAnimation() {
    self.userInteractionEnabled = false
    
    let currentHeight: CGFloat = self.frame.size.height
    self.loadingStateWidthConstraints.left?.deactivate()
    self.loadingStateWidthConstraints.right?.deactivate()
    
    self.buttonView.snp_updateConstraints { (make) -> Void in
      make.width.greaterThanOrEqualTo(currentHeight)
    }
    
    UIView.animateKeyframesWithDuration(0.40, delay: 0.0, options: [], animations: { () -> Void in
      self.buttonLabel.alpha = 1.0
      self.spinnerImageView.alpha = 0.0
      
      UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.2, animations: { () -> Void in
        self.buttonLabel.alpha = 0.0
      })
      
      UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
        self.spinnerImageView.alpha = 1.0
      })
      
      self.layoutIfNeeded()
      }) { (complete: Bool) -> Void in
        if complete {
          self.setLoadingState(true)
        }
    }
  }
  
  // TODO: these functions are a bit misleading, they dont just stretch/compress, they update state - should be renamed
  internal func attachStretchAnimationToButton() {

    self.loadingStateWidthConstraints.left?.activate()
    self.loadingStateWidthConstraints.right?.activate()
    UIView.animateKeyframesWithDuration(0.25, delay: 0.0, options: [], animations: { () -> Void in
      
      self.buttonLabel.alpha = 0.0
      self.setLoadingState(false)
      
      UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.3, animations: { () -> Void in
        self.updateButtonToState(.Following)
        self.buttonLabel.alpha = 1.0
        self.spinnerImageView.alpha = 0.0
      })
      
        self.layoutIfNeeded()
      }) { (complete: Bool) -> Void in
        // TODO: consider having a block that can be set as a variable and executed here if needed
        if complete {
        }
    }
    
  }
  
  private func attachRotationAnimationToSpinner() {
    
    // annoyingly, it seems that it is necessary to split up the rotations into multiple animation calls
    UIView.animateKeyframesWithDuration(1.15, delay: 0.0, options: [.Repeat, .BeginFromCurrentState, .CalculationModePaced], animations: { () -> Void in
      
      UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.25, animations: { () -> Void in
        self.spinnerImageView.layer.transform = CATransform3DMakeRotation(self.degreesToRad(90.0), 0.0, 0.0, -1.0)
      })
      
      UIView.addKeyframeWithRelativeStartTime(0.25, relativeDuration: 0.20, animations: { () -> Void in
        self.spinnerImageView.layer.transform = CATransform3DMakeRotation(self.degreesToRad(180.0), 0.0, 0.0, -1.0)
      })
      
      UIView.addKeyframeWithRelativeStartTime(0.55, relativeDuration: 0.30, animations: { () -> Void in
         self.spinnerImageView.layer.transform = CATransform3DMakeRotation(self.degreesToRad(270.0), 0.0, 0.0, -1.0)
      })
      
      UIView.addKeyframeWithRelativeStartTime(0.75, relativeDuration: 0.25, animations: { () -> Void in
        self.spinnerImageView.layer.transform = CATransform3DMakeRotation(self.degreesToRad(360.0), 0.0, 0.0, -1.0)
      })
      
      }) { (complete: Bool) -> Void in
        self.attachRotationAnimationToSpinner()
    }
    
  }
  
  
  // MARK: - Helpers
  // ------------------------------------------------------------
  private func degreesToRad(degrees: CGFloat) -> CGFloat {
    return degrees * (CGFloat(M_PI) / 180.0)
  }
  
  
  // MARK: - Button Control Actions
  // ------------------------------------------------------------
  internal func followButtonTapped(sender: AnyObject?) {
    self.startButtonLoadingAnimation()
    // TODO: adjust stretch/compress animation depending on its current state
    // TODO: delegate will need to signal that animation should begin/end
  }
  
  internal func followButtonHighlighted(sender: AnyObject?) {
    if self.currentState == .NotFollowing {
      self.buttonLabel.textColor = ConceptColors.MediumBlue
    } else {
      self.buttonLabel.textColor = ConceptColors.DarkText
    }
  }
  
  internal func followButtonReleased(sender: AnyObject?) {
    if self.currentState == .Following {
      self.buttonLabel.textColor = ConceptColors.DarkText
    } else {
      self.buttonLabel.textColor = ConceptColors.MediumBlue
    }
    
  }
  
}