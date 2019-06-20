//
//  ContactCell.swift
//  JeniusTest
//
//  Created by Agil Febrianistian on 14/06/19.
//  Copyright © 2019 agil. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactAgeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ model: ContactResponse){
        
        contactNameLabel.text = "\(String(describing: model.firstName ?? ""))"+" "+"\(String(describing: model.lastName ?? ""))"
        contactAgeLabel.text = "\(String(describing: model.age ?? 0))"
        contactImage.sd_setImage(with: URL(string: model.photo ?? ""), placeholderImage: UIImage(named: "placeholder-avatar"))
        
    }
    
    
}
