//
//  SWFController.swift
//  Swift Web Framework
//
//  Created by Marc Giroux on 2018-05-20.
//

import Foundation
import PerfectHTTP
import PerfectHTTPServer

public protocol SWFInitializable
{
    init()
    func routes()
}

public func createInstanceOfController<T>(object:T.Type) -> T where T:SWFInitializable
{
    let obj = object.init()
    obj.routes()
    return obj
}

open class SWFController: SWFInitializable
{
    open static var server: SWFServer!
    open weak var response: SWFServerResponse?
    open let view = SWFView()
    
    open static func setServer(_ server: SWFServer)
    {
        SWFController.server = server
    }
    
    public required init() {}
    open func routes() {}
    
    open func server() -> SWFServer
    {
        return SWFController.server
    }
    
    open func setResponse(_ response: SWFServerResponse)
    {
        self.response      = response
        self.view.response = response
    }
}
