//
//  FollowButton.swift
//  FollowButtonConcept
//
//  Created by Louis Tur on 5/3/16.
//  Copyright © 2016 SRLabs. All rights reserved.
//

import UIKit
import SnapKit

internal class FollowButton: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setupViewHierarchy()
    self.configureConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  internal func tappedFollow(sender: AnyObject) {
    print("tapped follow")
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
  
  // MARK: - Button Control Actions
  internal func followButtonTapped(sender: AnyObject?) {
    print("follow button tapped")
    self.buttonLabel.textColor = ConceptColors.DarkText
    
    // TODO: animation
  }
  
  internal func followButtonHighlighted(sender: AnyObject?) {
    self.buttonLabel.textColor = ConceptColors.MediumBlue
  }
  
  internal func followButtonReleased(sender: AnyObject?) {
    self.buttonLabel.textColor = ConceptColors.DarkText
  }
  
}