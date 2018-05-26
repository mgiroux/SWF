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
    public static var server: SWFServer!
    public weak var response: SWFServerResponse?
    public let view = SWFView()
    
    public static func setServer(_ server: SWFServer)
    {
        SWFController.server = server
    }
    
    public required init() {}
    public func routes() {}
    
    public func server() -> SWFServer
    {
        return SWFController.server
    }
    
    public func setResponse(_ response: SWFServerResponse)
    {
        self.response      = response
        self.view.response = response
    }
}
