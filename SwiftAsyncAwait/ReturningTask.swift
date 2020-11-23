//
//  ReturningTask.swift
//  SwiftAsyncAwait
//
//  Created by Admin on 7/2/18.
//  Copyright © 2018 cbrenneisen. All rights reserved.
//

import Foundation

public class ReturningTask<T>:BasicTask<T> {
    
    private var runningqueue:DispatchQueue;
    
    
    private init(_ queue: DispatchQueue) {
        runningqueue = queue;
        super.init();
    }
    
    override init() {
        runningqueue = DispatchQueue.global();
        super.init();
    }
    
    
    public static func run(_ task: @escaping () throws -> T, _ queue: DispatchQueue = DispatchQueue.global(), qos:DispatchQoS = DispatchQoS.userInitiated) -> ReturningTask<T> {
        let temp:ReturningTask<T> = ReturningTask<T>(queue);
        let item = DispatchWorkItem(block:{[unowned temp] in
            do {
                temp.value = try task();
            }
            catch {
                temp.errorException = MultipleThrownError(error);
            }
        });
        queue.async(execute: item);
        return temp;
    }
    
    //this runs on the UI thread
    public static func runOnUI(_ task: @escaping () throws -> T) -> ReturningTask<T> {
        if(Thread.isMainThread) {
            let temp:ReturningTask<T> = ReturningTask<T>(DispatchQueue.main);
            do {
                temp.value = try task();
            }
            catch {
                temp.errorException = MultipleThrownError(error);
            }
            return temp;
        }
        else {
            return run(task,DispatchQueue.main);
        }
    }
    
    //chain here (if you want to)
    //qos:DispatchQoS = DispatchQoS.userInitiated
    public func continueWith(_ task: @escaping (_ result:T) throws -> T,_ queue: DispatchQueue = DispatchQueue.global(), qos:DispatchQoS = DispatchQoS.default) -> ReturningTask<T> {
        let temp:ReturningTask<T> = ReturningTask<T>(queue);
        if(!self.iscomplete) {
            forceWait();
        }
        queue.async(execute:{[unowned temp, self] in
            do {
                temp.value = try task(self.value);
            }
            catch {
                if(self.errorException == nil) {
                    temp.errorException = MultipleThrownError(error);
                }
                else {
                    let newerror = MultipleThrownError(self.errorException!.errors);
                    newerror.append(error);
                    temp.errorException = newerror;
                }
            }
        });
        return temp;
    }
    
    //here, we continue on the same queue as we were on
    public func continueWith(_ task: @escaping (_ result:T) throws -> T) -> ReturningTask<T> {
        return continueWith(task, self.runningqueue);
    }
    
    //here, we reroute to the UI thread
    public func continueOnUI(_ task: @escaping (_ result:T) throws -> T) -> ReturningTask<T> {
        if(Thread.isMainThread) {
            return executeWhileAlreadyOnUIThread(task);
        }
        else {
            return continueWith(task, DispatchQueue.main, qos:DispatchQoS.userInitiated);
        }
    }
    
    private func executeWhileAlreadyOnUIThread(_ task: @escaping (_ result:T) throws -> T) -> ReturningTask<T> {
        let temp:ReturningTask<T> = ReturningTask<T>(DispatchQueue.main);
        if(!self.iscomplete) {
            forceWait();
        }
        do {
            temp.value = try task(self.value);
        }
        catch {
            if(self.errorException == nil) {
                temp.errorException = MultipleThrownError(error);
            }
            else {
                let newerror = MultipleThrownError(self.errorException!.errors);
                newerror.append(error);
                temp.errorException = newerror;
            }
        }
        return temp;
    }
}
