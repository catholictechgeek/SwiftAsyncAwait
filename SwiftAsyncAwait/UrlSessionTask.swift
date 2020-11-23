//
//  UrlSessionTask.swift
//  SwiftAsyncAwait
//
//  Created by Admin on 8/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

/*
public class URLSessionTask {
    var session:URLSession;
    
    public init(startAutomatically:Bool = true) {
        session = URLSession.shared;
    }
    
    public init(session:URLSession, startAutomatically:Bool = true) {
        self.session = session;
    }
    
    public func dataTask<T>(with url: URL) -> ReturningTask<T?> where T : Decodable {
        let task = ReturningTask<T?>();
        session.dataTask(with: url) { (data, resp, exception) in
            guard let bits = data else {
                task.errorException = MultipleThrownError(exception!);
                return;
            }
            let decoder = JSONDecoder();
            task.value = try? decoder.decode(T.self, from: bits);
            }.resume();
        return task;
    }
    
    public func start() {
        
    }
}
 */
public extension URLSession {
    func dataTaskAsync<T>(with url: URL) -> ReturningTask<T?> where T : Decodable {
        let task = ReturningTask<T?>();
        self.dataTask(with: url) { (data, resp, exception) in
            guard let bits = data else {
                task.errorException = MultipleThrownError(exception!);
                return;
            }
            let decoder = JSONDecoder();
            task.value = try? decoder.decode(T.self, from: bits);
        }.resume();
        return task;
    }
}
