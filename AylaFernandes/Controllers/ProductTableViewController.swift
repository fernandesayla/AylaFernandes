//
//  ProductTableViewController.swift
//  AylaFernandes
//
//  Created by Ayla Fernandes on 4/25/18.
//  Copyright © 2018 Ayla Fernandes. All rights reserved.
//

import UIKit
import CoreData


class ProductTableViewController: UITableViewController {
    
    var fetchedResultController: NSFetchedResultsController<Product>!
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         loadProducts()
        label.sizeToFit()
        label.textAlignment = .center;
        label.text = "Sua lista está vazia!"

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productSegue" {
            let vc = segue.destination as! AddEditViewController
            
            if let products = fetchedResultController.fetchedObjects{
                 vc.product = products[tableView.indexPathForSelectedRow!.row]
            }
            
        }
        
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let count = fetchedResultController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        guard let product = fetchedResultController.fetchedObjects?[indexPath.row] else {
          return cell
        }
        cell.prepare(with: product)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          
            guard let product = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            do {
                context.delete(product)
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
        
}



extension ProductTableViewController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .delete:
                if let indexPath = indexPath{
                    tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            default:
                tableView.reloadData()
        }
    }
}
