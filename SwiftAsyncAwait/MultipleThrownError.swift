//
//  MultipleThrownError.swift
//  SwiftAsyncAwait
//
//  Created by Admin on 7/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
public class MultipleThrownError:Error {
    private var errorsthrown:[Error];
    
    internal init(_ exception:Error) {
        errorsthrown = [exception];
    }
    
    internal init(_ exceptions:[Error]) {
        errorsthrown = exceptions;
    }
    
    public var errors:[Error] {
        get {return errorsthrown;}
    }
    
    public var lastError:Error? {
        get {
            if(errorsthrown.count < 1) {
                return nil;
            }
            else {
                return errorsthrown[(errorsthrown.count - 1)];
            }
        }
    }
    
    internal var errorCount:Int {
    get {return self.errorsthrown.count;}
    }
    
    internal func append(_ newerror:Error) {
        errorsthrown.append(newerror);
    }
}
