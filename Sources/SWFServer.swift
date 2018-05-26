//
//  SWFServer.swift
//  Swift Web Framework
//
//  Created by Marc Giroux on 2018-05-19.
//

import Foundation
import PerfectHTTP
import PerfectHTTPServer
import MongoDBStORM

public typealias SWFServerResponse = HTTPResponse
public typealias SWFServerRequest  = HTTPRequest

public class SWFServer
{
    private let instance = HTTPServer()
    public let router    = SWFRouter()
    public var config    = SWFConfig()
    public let rootPath  = Bundle.main.bundlePath
    
    public static let version = "1.0.0-alpha"
    public static let name    = "Swift Web Framework"
    
    init()
    {
        // Load configuration
        let configPath = Bundle.main.bundlePath + "/config/config.json"
        
        do {
            let jsonString = try String(contentsOfFile: configPath, encoding: .utf8)
            let decoder    = JSONDecoder()
            
            do {
                let data    = jsonString.data(using: .utf8)!
                self.config = try decoder.decode(SWFConfig.self, from: data)
                
                // Connect to database (MongoDB)
                MongoDBConnection.host     = self.config.env().database.host
                MongoDBConnection.port     = self.config.env().database.port
                MongoDBConnection.ssl      = self.config.env().database.ssl
                MongoDBConnection.database = self.config.env().database.database
                
                // Auth if needed
                if self.config.env().database.username != "" {
                    MongoDBConnection.authmode = .standard
                    MongoDBConnection.username = self.config.env().database.username
                    MongoDBConnection.password = self.config.env().database.password
                }
                
                // Start server
                self.instance.serverName    = self.config.env().name
                self.instance.serverPort    = UInt16(self.config.env().port)
                self.instance.serverAddress = self.config.env().bind
                
                // Enable compression
                if self.config.env().useCompression {
                    let compress = try! PerfectHTTPServer.HTTPFilter.contentCompression(data: [:])
                    self.instance.setResponseFilters([(compress, .high)])
                }
            } catch {
                print("Errors were found in the configuration file:")
                fatalError("\(error)")
            }
        } catch _ {
            fatalError("Could not locate configuration file. Looked in \(configPath)")
        }
    }
    
    public func start()
    {
        // Add all routes from all controllers
        self.instance.addRoutes(self.router.routes)
        
        // Add all groups
        for group in self.router.groups {
            self.instance.addRoutes(group.value)
        }
        
        do {
            try self.instance.start()
        } catch {
            print("Could not launch web server")
            fatalError("\(error)")
        }
    }
}
