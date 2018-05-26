//
//  SWFConfig.swift
//  Swift Web Framework
//
//  Created by Marc Giroux on 2018-05-19.
//

import Foundation

public struct SWFConfig: Codable
{
    var environment = "development"
    var development = SWFEnvironmentConfig()
    var production  = SWFEnvironmentConfig()
    
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
    var name           = "localhost"
    var port           = 8181
    var bind           = "0.0.0.0"
    var useCompression = false
    var database       = SWFDatabaseConfig()
    var security       = SWFSecurityConfig()
}

public struct SWFDatabaseConfig: Codable
{
    var host     = ""
    var database = ""
    var username = ""
    var password = ""
    var port     = 27017
    var ssl      = false
}

public struct SWFSecurityConfig: Codable
{
    var salt          = ""
    var encryptionKey = ""
}
