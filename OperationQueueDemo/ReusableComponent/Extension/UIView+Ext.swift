//
//  UIView+Ext.swift
//  OperationQueueDemo
//
//  Created by JungpyoHong on 5/5/21.
//

import UIKit

extension UIView {
    struct Sides: OptionSet {
        let rawValue: Int
        
        static let none = Sides(rawValue: 1<<0)
        static let leading = Sides(rawValue: 1<<1)
        static let top = Sides(rawValue: 1<<2)
        static let trailing = Sides(rawValue: 1<<3)
        static let bottom = Sides(rawValue: 1<<4)
        
        static let horizontal: Sides = [.leading, .trailing]
        static let vertical: Sides = [.top, .bottom]
        static let all: Sides = [.leading, .trailing, .top, .bottom]
    }
    
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leadingAnchor
        } else {
            return self.leadingAnchor
        }
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.trailingAnchor
        } else {
            return self.trailingAnchor
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
    
    static func viewWithOutARMask() -> Self {
        let view = Self()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    @discardableResult
    func addConstrainedSubView(_ view: UIView,
                               withEdgeInsets insets: UIEdgeInsets = .zero,
                               withLooseEnd ends: Sides = .none) -> [NSLayoutConstraint] {
        if view.superview != self { self.addSubview(view) }
        let constraints = [
            constraint((fromView: view.leadingAnchor, toView: self.leadingAnchor), constant: insets.left, isLoose: ends.contains(.leading)),
            
            constraint((fromView: view.topAnchor, toView: self.topAnchor), constant: insets.top, isLoose: ends.contains(.top)),
            
            constraint((fromView: self.trailingAnchor, toView: view.trailingAnchor), constant: insets.right, isLoose: ends.contains(.trailing)),
            
            constraint((fromView: self.bottomAnchor, toView: view.bottomAnchor), constant: insets.bottom, isLoose: ends.contains(.bottom)),
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    @discardableResult
    func addSafeConstrainedSubView(_ view: UIView,
                                   withEdgeInsets insets: UIEdgeInsets = .zero,
                                   withLooseEnd ends: Sides = .none,
                                   ignoringSafeAreaForSides sides: Sides = .none) -> [NSLayoutConstraint] {
        if view.superview != self { self.addSubview(view) }
        let constraints = [
            constraint((fromView: view.leadingAnchor,
                        toView: sides.contains(.leading) ? self.leadingAnchor : safeLeadingAnchor),
                       constant: insets.left,
                       isLoose: ends.contains(.leading)),
            
            constraint((fromView: view.topAnchor,
                        toView: sides.contains(.top) ? self.topAnchor : safeTopAnchor),
                       constant: insets.top,
                       isLoose: ends.contains(.top)),
            
            constraint((fromView: sides.contains(.trailing) ? self.trailingAnchor : safeTrailingAnchor,
                        toView: view.trailingAnchor),
                       constant: insets.right, isLoose:
                        ends.contains(.trailing)),
            
            constraint((fromView: sides.contains(.bottom) ? self.bottomAnchor : safeBottomAnchor,
                        toView: view.bottomAnchor),
                       constant: insets.bottom,
                       isLoose: ends.contains(.bottom)),
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    private func constraint<AnchorType: AnyObject>(_ anchors:(fromView: NSLayoutAnchor<AnchorType>,
                                                              toView: NSLayoutAnchor<AnchorType>),
                                                   constant: CGFloat,
                                                   isLoose: Bool) -> NSLayoutConstraint {
        isLoose ? anchors.fromView.constraint(greaterThanOrEqualTo: anchors.toView, constant: constant) : anchors.fromView.constraint(equalTo: anchors.toView, constant: constant)
    }
}
