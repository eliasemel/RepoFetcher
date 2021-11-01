//
//  UIView+Contraints.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-09-28.
//

import Foundation
import UIKit

extension UIView {
	
	/// Prepares the view for adding constraints and adds it as a subview
	///
	/// - Parameter childView: view that is intended to have constraints
	public func autoLayoutAddSubview(childView: UIView) {
		childView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(childView)
	}
	
	/// Fills the caller view with the view passed as argument
	/// please note, the argument view should be added as subview by
	/// autoLayoutAddSubView before executing the function
	/// - Parameter childView: The child view to be filled
	public func addConstraintsToFill(childView: UIView) {
		let horizontalConstraints = NSLayoutConstraint.constraints(
			withVisualFormat: "H:|[V1]|",
			metrics: nil,
			views: ["V1": childView])
		self.addConstraints(horizontalConstraints)
		let verticalConstraints = NSLayoutConstraint.constraints(
			withVisualFormat: "V:|[V1]|",
			metrics: nil,
			views: ["V1": childView])
		self.addConstraints(verticalConstraints)
	}
	
	/// Aligns the view horizontally center on the caller view
	/// please note, the argument view should be added as subview by
	/// autoLayoutAddSubView before executing the function
	/// - Parameter childView: The child view to be aligned horizontally center
	public func positionCenterHorizontally(childView: UIView) {
		let xCenterConstraint = NSLayoutConstraint(
			item: childView,
			attribute: .centerX,
			relatedBy: .equal,
			toItem: self,
			attribute: .centerX,
			multiplier: 1,
			constant: 0)
		self.addConstraint(xCenterConstraint)
	}
	
	/// Aligns the view vertically center on the caller view
	/// please note, the argument view should be added as subview by
	/// autoLayoutAddSubView before executing this function
	/// - Parameter childView: The child view to be aligned vertically center
	public func positionCenterVertically(childView: UIView) {
		let yCenterConstraint = NSLayoutConstraint(
			item: childView,
			attribute: .centerY,
			relatedBy: .equal,
			toItem: self,
			attribute: .centerY,
			multiplier: 1,
			constant: 0)
		self.addConstraint(yCenterConstraint)
	}
	
	/// Aligns the view in center on the caller view
	/// please note, the argument view should be added as subview by
	/// autoLayoutAddSubView before executing this function
	/// - Parameter childView: the child view to be aligned in center
	public func positionCenter(childView: UIView) {
		self.positionCenterVertically(childView: childView)
		self.positionCenterHorizontally(childView: childView)
	}
	
	public func addHeightConstraint(ratio: CGFloat, forView: UIView) {
		self.addConstraint(
			NSLayoutConstraint(
				item: forView,
				attribute: .height,
				relatedBy: .equal,
				toItem: self,
				attribute: .height,
				multiplier: ratio,
				constant: 0))
	}
	
	public func addWidthConstraint(ratio: CGFloat, forView: UIView) {
		self.addConstraint(
			NSLayoutConstraint(
				item: forView,
				attribute: .width,
				relatedBy: .equal,
				toItem: self,
				attribute: .width,
				multiplier: ratio,
				constant: 0))
	}
	
	/// Adds constraints for the width and height anchor of this view to be equal to the given constant size.
	///
	/// - Parameter size: The constant size to which to constrain this view.
	public func addConstantSizeConstraints(size: CGSize) {
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalToConstant: size.width),
			heightAnchor.constraint(equalToConstant: size.height),
		])
	}
}
