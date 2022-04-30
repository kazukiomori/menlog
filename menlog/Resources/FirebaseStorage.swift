//
//  FirebaseStorage.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/17.
//

import FirebaseStorage

public class StorageManager {
    
    let shared = StorageManager()
    
    let bucket = Storage.storage().reference()
}
