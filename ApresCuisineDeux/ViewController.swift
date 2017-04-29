//
//  ViewController.swift
//  ApresCuisineDeux
//
//  Created by Himaja Motheram on 4/25/17.
//  Copyright © 2017 Sriram Motheram. All rights reserved.
//


import UIKit
import Parse

class ViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var DishTableView: UITableView!
    
    var DishArray = [Dish]()
    
    @IBOutlet weak var CreateNew: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueShow"{
            let destinationVC = segue.destination as! DetailViewController
            let indexPath = DishTableView.indexPathForSelectedRow!
            let currentTask = DishArray[indexPath.row]
            
            destinationVC.currentdish = currentTask
            DishTableView.deselectRow(at: indexPath, animated: true)
            
        }
        else if segue.identifier == "seguenew" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.currentdish = nil
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFoodDishes()
        //  TaskList = appDelegate.fetchAllTasks()
        DishTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DishArray.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dishcell", for: indexPath)
        let currentDish = DishArray[indexPath.row]
        
        cell.textLabel!.text = "Name: \(currentDish.name )"
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let result = formatter.string(from: currentDish.dateeaten! )
        
        cell.detailTextLabel!.text = "\(result), \(currentDish.rating),\(currentDish.review)"
        
        //   print("here1")
        return cell
    }
    
    func fetchFoodDishes() {
        let query = PFQuery(className: "Dish")
        query.limit = 1000
        query.order(byDescending: "dateeaten")
        query.findObjectsInBackground { (results, error) in
            if let err = error {
                print("Got error \(err.localizedDescription)")
            } else {
                self.DishArray = results as! [Dish]
                print("Count: \(self.DishArray.count)")
                //print("\(self.DishArray)")
                // let dish = self.DishArray[1]
                // print("\(dish.review)")
                self.DishTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = DishArray[indexPath.row]
            taskToDelete.deleteInBackground(block: { (sucess, error) in
                
                self.fetchFoodDishes()
                //self.DishTableView.deleteRows(at: [indexPath], with: .automatic)
                // tableView.isEditing = false
            })
            
        }
        
        
    }
    
    
    
}
