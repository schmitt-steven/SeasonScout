//
//  FruitVegetable.swift
//  ios-project
//
import Foundation

struct FruitVegetable: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let availability: [MonthAvailability]
    let category: ProductType
}
