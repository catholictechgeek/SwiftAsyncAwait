//
//  BasicTask.swift
//  SwiftAsyncAwait
//
//  Created by Admin on 8/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

public class BasicTask<T> {
    private var val: T?;
    private var thrownerror: MultipleThrownError?;
    internal var iscomplete:Bool;
    
    internal init() {
        iscomplete = false;
    }
    
    internal(set) public var value:T {
        get{
            while((!self.iscomplete)) {
                forceWait();
            }
            /*
            if(thrownerror != nil) {
                throw thrownerror!;
            }
 */
            return val!;
        }
        set{
            val = newValue;
            iscomplete = true;
        }
    }
    
    internal(set) public var errorException:MultipleThrownError? {
        get{return thrownerror;}
        set {
            thrownerror = newValue;
            iscomplete = true;
        }
    }
    
    internal func forceWait() {
        sleep(2);
    }
    
    public func awaitResult() -> T {
        return value;
    }
}
