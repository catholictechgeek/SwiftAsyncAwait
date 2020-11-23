//
//  BlockerTask.swift
//  SwiftAsyncAwait
//
//  Created by Admin on 8/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
public class BlockerTask<T> {
    private var internaltask:ReturningTask<T>;
    
    init() {
        internaltask = ReturningTask<T>();
    }
    
    public var task:ReturningTask<T> {
        get{return internaltask;}
    }
    
    public func setValue(value:T) {
        internaltask.value = value;
    }
}
