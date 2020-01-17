//
//  ContactCell.swift
//  Assessments
//
//  Created by Kai Xuan on 18/01/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    var contactImageView = UIImageView()
    var contactNameLabel = UILabel()
    
    var contactModel: Contact! {
        didSet{
            contactNameLabel.text = "\(contactModel.firstName) \(contactModel.lastName)"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contactImageView)
        addSubview(contactNameLabel)
        
        setImageConstraints()
        setLabelConstraints()
        configureImageView()
        configureTitleLabel()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configureImageView() {
        contactImageView.layer.cornerRadius = 30
        contactImageView.clipsToBounds      = true
        contactImageView.backgroundColor    = hexStringToUIColor(hex: appConstant.themeColor)
    }
    
    func configureTitleLabel() {
        contactNameLabel.numberOfLines              = 1
        contactNameLabel.adjustsFontSizeToFitWidth  = true
    }
    
    func setImageConstraints() {
        contactImageView.translatesAutoresizingMaskIntoConstraints                                  = false
        contactImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                  = true
        contactImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive    = true
        contactImageView.heightAnchor.constraint(equalToConstant: 60).isActive                      = true
        contactImageView.widthAnchor.constraint(equalToConstant: 60).isActive                       = true
    }
    
    func setLabelConstraints() {
        contactNameLabel.translatesAutoresizingMaskIntoConstraints                                                      = false
        contactNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                      = true
        contactNameLabel.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 16).isActive      = true
        contactNameLabel.heightAnchor.constraint(equalToConstant: 60).isActive                                          = true
        contactNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive                     = true
    }

}
