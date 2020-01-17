//
//  UIView+Ext.swift
//  Assessments
//
//  Created by Kai Xuan on 17/01/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func pin(to superView: UIView){
        translatesAutoresizingMaskIntoConstraints                               = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive             = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive     = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive   = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive       = true
    }
    
}
