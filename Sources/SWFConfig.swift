//
//  SWFConfig.swift
//  Swift Web Framework
//
//  Created by Marc Giroux on 2018-05-19.
//

import Foundation

public struct SWFConfig: Codable
{
    public var environment = "development"
    public var development = SWFEnvironmentConfig()
    public var production  = SWFEnvironmentConfig()
    
    public func env() -> SWFEnvironmentConfig
    {
        if self.environment == "development" {
            return self.development
        }
        
        return self.production
    }
}

public struct SWFEnvironmentConfig: Codable
{
    public var name           = "localhost"
    public var port           = 8181
    public var bind           = "0.0.0.0"
    public var useCompression = false
    public var database       = SWFDatabaseConfig()
    public var security       = SWFSecurityConfig()
    public var custom         = [String: String]()
}

public struct SWFDatabaseConfig: Codable
{
    public var host     = ""
    public var database = ""
    public var username = ""
    public var password = ""
    public var port     = 27017
    public var ssl      = false
}

public struct SWFSecurityConfig: Codable
{
    public var salt          = ""
    public var encryptionKey = ""
}
