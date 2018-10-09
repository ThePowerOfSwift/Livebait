//
//  MSProduct.swift
//  iCheckbook
//
//  Created by maninder on 4/19/17.
//  Copyright © 2017 maninder. All rights reserved.
//

import Foundation
import StoreKit


public struct MSProduct {
    
    public static let searchProduct = "GoogleDriveAddOn"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [MSProduct.searchProduct]
    
    public static let store = MSPurchaseHelper(productIds: MSProduct.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
