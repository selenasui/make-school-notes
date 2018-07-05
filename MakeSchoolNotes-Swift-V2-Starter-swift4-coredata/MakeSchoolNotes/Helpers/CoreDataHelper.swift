//
//  CoreDataHelper.swift
//  MakeSchoolNotes
//
//  Created by Binjia Chen on 7/5/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newNote() -> Note {
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        
        return note
    }
    
    static func saveNote() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func deleteNote(note: Note) {
        context.delete(note)
        
        saveNote()
    }
    
    static func retrieveNotes() -> [Note]{
        do {
            let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
            var results = try context.fetch(fetchRequest)
            
            results.sort { $0.modificationTime! > $1.modificationTime! }
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
}
