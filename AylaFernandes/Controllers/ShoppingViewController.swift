//
//  ViewController.swift
//  AylaFernandes
//
//  Created by Ayla Fernandes on 4/23/18.
//  Copyright © 2018 Ayla Fernandes. All rights reserved.
//

import UIKit
import CoreData

class ShoppingViewController: UIViewController {

    
    @IBOutlet weak var lbTotalDollars: UILabel!
    
    @IBOutlet weak var lbTotalReals: UILabel!
    
    var  config = Settings.shared
     var fetchedResultController: NSFetchedResultsController<Product>!
    
    func amount(){
        var amountReals: Double = 0.0
        var amountDollar: Double = 0.0
        for product in fetchedResultController.fetchedObjects! {
            amountReals += tc.calculateProductRealValue(of: product)
            amountDollar += product.dollarPrice
        }
        lbTotalDollars.text = tc.getFormattedValue(of: amountDollar, with: "")
        lbTotalReals.text = tc.getFormattedValue(of: amountReals, with: "")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          loadProducts()
        amount()
    }
    
    func loadProducts(){
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do{
            try fetchedResultController.performFetch()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ShoppingViewController : NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
       amount()
    }
}

