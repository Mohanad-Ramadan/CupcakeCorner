//
//  Order.swift
//  CupcakeCorner
//
//  Created by Mohanad Ramdan on 31/07/2023.
//

import SwiftUI

class Order : ObservableObject {
    struct Ordering: Codable {
        var type = 0
        var quantity = 3
        var specialRequestEnabled = false {
            didSet {
                if specialRequestEnabled == false {
                    extraFrosting = false
                    addSprinkles = false
                }
            }
        }
        var extraFrosting = false
        var addSprinkles = false
        
        var fullName = ""
        var streetAddress = ""
        var city = ""
        var zipCode = ""
        
        var isNotValid :Bool {
            if fullName.trimmingCharacters(in: .whitespaces).isEmpty || streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zipCode.trimmingCharacters(in: .whitespaces).isEmpty {
                return false
            }
            return true
        }
        
        var rightImage: String  {
            switch type {
            case 0: return ImageURL().vanilla
            case 1: return ImageURL().strawberry
            case 2: return ImageURL().chocolate
            default: return ImageURL().rainbow
            }
        }
        
        var cost: Double {
            var cost = Double(quantity) * 2
            cost += (Double(type) / 2)
            if extraFrosting {
                cost += Double(quantity)
            }
            if addSprinkles {
                cost += Double(quantity) / 2
            }
            return cost
        }
    }

    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var ordering = Ordering()
        
}
