//
//  SettingsViewController.swift
//  AylaFernandes
//
//  Created by Ayla Fernandes on 4/23/18.
//  Copyright © 2018 Ayla Fernandes. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbDollarExchangeRate: UITextField!
    @IBOutlet weak var lbIOF: UITextField!
    
    var fetchedResultController: NSFetchedResultsController<States>!
    var label = UILabel()
    
     var state: States!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStates()
        
        label.text = "Sua lista está vazia!"
        // Do any additional setup after loading the view.
    }
    func loadStates(){
        let fetchRequest: NSFetchRequest<States> = States.fetchRequest()
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
    
    
    func showAlert(with state: States?){

        let title = state == nil ? "Adicionar"  : "Editar"
        let alert = UIAlertController(title: title + " Estado", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nome do Estado"
            if let name = state?.name{
                textField.text = name
            }
        }
        alert.addTextField { (textFieldTax) in
            textFieldTax.placeholder = "Taxa do Estado"
            if let tax =  state?.tax{
                textFieldTax.text = String(tax)
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
            let state = state ?? States(context: self.context)
            
            state.name = alert.textFields?.first?.text
            if let tax = alert.textFields?[1].text {
                state.tax =  self.tc.convertToDoble(tax)
            }
            
           
            do{
                try self.context.save()
                self.loadStates()
            }catch{
                print(error.localizedDescription)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addEditState(_ sender: Any) {
        
        showAlert(with: state)
    }

}

extension SettingsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
        
        return count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // tableView.deleteRows(at: [indexPath], with: .fade)
            
            guard let state = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            do {
                context.delete(state)
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! StatesTableViewCell

                guard let state = fetchedResultController.fetchedObjects?[indexPath.row] else {
                    return cell
                }

                cell.prepare(with: state)

                return cell
    }
    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatesTableViewCell
//
//        guard let state = fetchedResultController.fetchedObjects?[indexPath.row] else {
//            return cell
//        }
//
//        cell.prepare(with: state)
//
//        return cell
//    }
    
}

extension SettingsViewController: UITableViewDelegate{
    
}
extension SettingsViewController: NSFetchedResultsControllerDelegate{
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

