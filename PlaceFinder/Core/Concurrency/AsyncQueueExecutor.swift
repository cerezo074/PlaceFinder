//
//  AsyncQueueExecutor.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 16/01/25.
//

import Foundation

protocol TaskQueue: AnyObject {
    func execute(task: @escaping () -> Void)
    func execute(with delay: Double, task: @escaping () -> Void)
    func executeOnMainThread(task: @escaping () -> Void)
}

final class AsyncQueueExecutor: TaskQueue {
    let queue: DispatchQueue
    
    init(queue: DispatchQueue = .main) {
        self.queue = queue
    }
    
    func execute(task: @escaping () -> Void) {
        queue.async {
            task()
        }
    }
    
    func executeOnMainThread(task: @escaping () -> Void) {
        if Thread.isMainThread {
            task()
        } else {
            DispatchQueue.main.async {
                task()
            }
        }
    }
    
    func execute(with delay: Double, task: @escaping () -> Void) {
        queue.asyncAfter(deadline: .now() + delay) {
            task()
        }
    }
}
