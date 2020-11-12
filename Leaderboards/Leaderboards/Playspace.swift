//
//  Playspace.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/18/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import Foundation
import CloudKit

struct Playspace {
    
    let recordID: CKRecord.ID
    let name: String
    let password: String
    
}

// MARK: - CloudKit

extension Playspace {
    
    static let nameKey = "name"
    static let passwordKey = "password"
    static let recordType = "Playspace"
    
    init?(record: CKRecord) {
        guard let name = record[Playspace.nameKey] as? String,
            let password = record[Playspace.passwordKey] as? String else { return nil }
        
        self.recordID = record.recordID
        self.name = name
        self.password = password

    }
    
    var CKRepresentation: CKRecord {
        let record = CKRecord(recordType: Playspace.recordType, recordID: recordID)
        
        record.setValue(name, forKey: Playspace.nameKey)
        record.setValue(password, forKey: Playspace.passwordKey)
        
        return record
    }
    
}

// MARK: - Equatable

extension Playspace: Equatable {
    
    static func ==(lhs: Playspace, rhs: Playspace) -> Bool {
        return lhs.recordID == rhs.recordID
    }
    
}
