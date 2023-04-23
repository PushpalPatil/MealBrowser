//
//  ViewController.swift
//  MealBrowser

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var recipes = [[String:Any]]()
 
    var recipeID : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request){
            (data, response, error) in
            if let error = error{
                print(error.localizedDescription)
            }else if let data = data{
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.recipes = dataDictionary["meals"] as! [[String: Any]]
                self.tableView.reloadData()
                print(dataDictionary)
            }
        }
        task.resume()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
        let recipe = recipes[indexPath.row]
        let name = recipe["strMeal"] as! String
        recipeID = recipe["idMeal"] as! String
        let image = URL(string: recipe["strMealThumb"] as! String)
        
        cell.recipeName.text = name
        cell.recipeDescription.text = recipeID
        cell.recipeImage.af_setImage(withURL: image!)
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // find selected recipe
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let recipe = recipes[indexPath.row]
        
        // pass selected recipe to recipe detailsVC
        let detailsRecipe = segue.destination as! RecipeDetailsViewController
        detailsRecipe.recipe = recipe
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("loading up recipe details")
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func getRecipeID() -> String{
        return recipeID
    }
  
}



