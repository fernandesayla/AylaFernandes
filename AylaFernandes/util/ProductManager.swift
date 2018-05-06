//
//  StatesManager.swift
//  AylaFernandes
//
//  Created by Ayla Fernandes on 5/5/18.
//  Copyright © 2018 Ayla Fernandes. All rights reserved.
//

import UIKit
import CoreData

class ProductManager  {
    
    
    static let shared =  ProductManager()
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    var fetchedResultController: NSFetchedResultsController<Product>!
            var products: [Product] = []
    
    
    func loadProducts(with context: NSManagedObjectContext ){
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //fetchedResultController.delegate = self
        
        do{
            try fetchedResultController.performFetch()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    private init(){
        
    }
    
 
}
//
//extension ProductManager : NSFetchedResultsControllerDelegate{
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//    }
//}


