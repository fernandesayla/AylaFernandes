//
//  StatesManager.swift
//  AylaFernandes
//
//  Created by Ayla Fernandes on 5/5/18.
//  Copyright © 2018 Ayla Fernandes. All rights reserved.
//

import CoreData

class StateManager  {
     static let shared =  StateManager()
        var fetchedResultController: NSFetchedResultsController<States>!
        var states: [States] = []
        private init() {
    }
    
    func loadStates(with context: NSManagedObjectContext ){
        let fetchRequest: NSFetchRequest<States> = States.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            states = try context.fetch(fetchRequest)
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func deleteState(index: Int, context: NSManagedObjectContext){
        let state = states[index]
        context.delete(state)
         do {
            
            try context.save()
            states.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
    }
}

