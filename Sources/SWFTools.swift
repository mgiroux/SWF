//
//  SWFTools.swift
//  Swift Web Framework
//
//  Created by Marc Giroux on 2018-05-20.
//

import Foundation
import PerfectCURL

open class SWFTools
{
    open static func uuid() -> String
    {
        return UUID().uuidString
    }
    
    open static func getPID()
    {
        print(ProcessInfo.processInfo.processIdentifier)
    }
}
