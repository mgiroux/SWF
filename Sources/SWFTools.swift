//
//  SWFTools.swift
//  Swift Web Framework
//
//  Created by Marc Giroux on 2018-05-20.
//

import Foundation
import PerfectCURL

public class SWFTools
{
    public static func uuid() -> String
    {
        return UUID().uuidString
    }
    
    public static func getPID()
    {
        print(ProcessInfo.processInfo.processIdentifier)
    }
}
