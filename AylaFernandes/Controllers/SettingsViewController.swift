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
    @IBOutlet weak var tfDollarExchangeRate: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
   
    var label = UILabel()
    var state: States!
    var  sm = StateManager.shared
    var  config = Settings.shared
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        loadStates()
        label.sizeToFit()
        label.textAlignment = .center;
        label.text = "Sua lista está vazia!"
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        formatView()
    }
    
    func formatView(){
        tfIOF.text = tc.getFormattedValue(of: config.iof, with: "")
        tfDollarExchangeRate.text =   tc.getFormattedValue(of: config.dollarExchangeRate, with: "")
    }
    
    func loadStates(){
        sm.loadStates(with: context)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    
    
    func showAlert(with state: States?){

        let title = state == nil ? "Adicionar"  : "Editar"
        let alert = UIAlertController(title: title + " Estado", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nome do Estado"
            textField.keyboardType = .decimalPad
            
            if let name = state?.name{
                textField.text = name
            }
        }
        alert.addTextField { (textFieldTax) in
            textFieldTax.placeholder = "Taxa do Estado"
            textFieldTax.keyboardType = .decimalPad
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
        let count = sm.states.count
        tableView.backgroundView = count == 0 ? label : nil
        
        return count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source

            sm.deleteState(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
           
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = sm.states[indexPath.row]
        showAlert(with: state)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! StatesTableViewCell
                let state = sm.states[indexPath.row]
                cell.prepare(with: state)
                return cell
    }
    
}

extension SettingsViewController: UITableViewDelegate{
    
}
