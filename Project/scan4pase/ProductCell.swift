//
//  ProductCell.swift
//  scan4pase
//
//  Created by Dhruv Sringari on 7/5/16.
//  Copyright © 2016 Dhruv Sringari. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var sku: UILabel!
    @IBOutlet var pvBV: UILabel!
    @IBOutlet var retailCost: UILabel!
    @IBOutlet var iboCost: UILabel!

    func load(withProduct product: Product) {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        name.text = product.name
        sku.text = product.sku
        pvBV.text = formatter.string(from: product.pv!)! + "/" + formatter.string(from: product.bv!)!
        formatter.numberStyle = .currency
        retailCost.text = formatter.string(from: product.retailCost!)
        iboCost.text = formatter.string(from: product.iboCost!)
        if product.custom!.boolValue {
            sku.textColor = UIColor(red: 97, green: 188, blue: 109)
        } else {
            sku.textColor = UIColor(red: 43, green: 130, blue: 201)
        }
    }
}
