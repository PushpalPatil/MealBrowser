//
//  Recipe.swift
//  MealBrowser

import Foundation

struct Recipe{
    let recipeURL = "www.themealdb.com/api/json/v1/1/filter.php?c=Dessert"
//    let id: String
//    let recipeName: String
//    let instructions: String
//    let ingredients: [String : String]
//
    func getRecipe(recipeID:String){
        let url = "www.themealdb.com/api/json/v1/1/lookup.php?i=\(recipeID)"
    }
}
