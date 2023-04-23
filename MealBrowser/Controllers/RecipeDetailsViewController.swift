//
//  RecipeDetailsViewController.swift
//  MealBrowser
//

import UIKit
import AlamofireImage

class RecipeDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cuisine: UILabel!
    @IBOutlet weak var IngredientsListed: UILabel!
    
    
    var recipe : [String : Any]!
    var dessertInfo : [[String: Any]]!
    
    
    
    // strMeal, idMeal, strMealThumb
    // 
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = recipe["strMeal"] as? String
        IngredientsListed.text = "Ingredients: \n"
        IngredientsListed.preferredMaxLayoutWidth = IngredientsListed.frame.width
        
        var id = recipe["idMeal"]
        print(id!)
        
        
        let descriptionURL = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id!)")
        let request = URLRequest(url: descriptionURL!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request){ (data, response, error) in
            if let error = error{
                print(error.localizedDescription)
            }else if let data = data{
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.dessertInfo = dataDictionary["meals"] as? [[String: Any]]
                
                print(dataDictionary)
                
                if let meals = dataDictionary["meals"] as? [[String:Any]]{
                    if let dessert = meals[0] as? [String:Any]{
                        
                        self.cuisine.text = dessert["strArea"] as! String
                        
                        var i = 0
                        while i < 20{
                            guard let ingredient = dessert["strIngredient\(i)"] as? String,
                                  let measure = dessert["strMeasure\(i)"] as? String, !measure.isEmpty else {
                                i += 1
                                continue
                            }
                            let currIngredient = "\(i)) \(measure) \(ingredient)\n"
                            
                            self.IngredientsListed.text! += "\(currIngredient)\n"
                            
                            i += 1
                        }
                        
                        self.IngredientsListed.text! += "\n\nInstructions: \n\( dessert["strInstructions"] as! String) "
                        self.IngredientsListed.minimumScaleFactor = 0.5 // set the minimum scale factor
                        let textRect = self.IngredientsListed.frame // use the frame of the label as the bounding rectangle
                        
                        let fitSize = self.IngredientsListed.sizeThatFits(CGSize(width: textRect.width, height: CGFloat.greatestFiniteMagnitude)) // get the size of the label that fits the text
                        let finalHeight = CGFloat(fitSize.height) // calculate the final height of the label
                        self.IngredientsListed.frame.size.height = finalHeight // set the height of the label to the final height
                    }
                }
            }
            
        }
        task.resume()
        
        
        
        let image = URL(string: recipe["strMealThumb"] as! String)
        posterView.af_setImage(withURL: image!)
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
