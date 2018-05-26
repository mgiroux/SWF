//
//  SFWView.swift
//  Swift Web Framework
//
//  Created by Marc Giroux on 2018-05-20.
//

import Foundation
import Stencil
import PathKit

open class SWFView
{
    public weak var response: SWFServerResponse?
    public let templatePath = Bundle.main.bundlePath
    
    static public var extensions = Extension()
    
    init()
    {
        // Register all system extensions
        self.registerSystemExtensions()
    }
    
    public func render(_ file: String, data: [String: Any])
    {
        var html = ""
        
        let fslPath     = Path(self.templatePath + "/templates")
        let fsl         = FileSystemLoader(paths: [fslPath])
        let environment = Environment(loader: fsl, extensions: [SWFView.extensions])

        do {
            html = try environment.renderTemplate(name: file, context: data)
        } catch {}
        
        self.response?.setHeader(.contentType, value: "text/html")
        self.response?.setHeader(.contentEncoding, value: "UTF-8")
        self.response?.appendBody(string: html)
        self.response?.completed()
    }
    
    public func render(data: [String: Any])
    {
        self.response?.setHeader(.contentType, value: "application/json")
        self.response?.setHeader(.contentEncoding, value: "UTF-8")
        
        do {
            let json = try data.jsonEncodedString()
            self.response?.appendBody(string: json)
        } catch {
            self.response?.appendBody(string: "{\"message\": \"Couldn ot convert dictionary to JSON\"}")
        }
        
        self.response?.completed()
    }
    
    public func partial(_ file: String, data: [String: Any]) -> String
    {
        var html = ""
        
        let fslPath     = Path(self.templatePath + "/templates/includes")
        let fsl         = FileSystemLoader(paths: [fslPath])
        let environment = Environment(loader: fsl, extensions: [SWFView.extensions])
        
        do {
             html = try environment.renderTemplate(name: file, context: data)
        } catch {
             html = "<!-- Partial not found -->"
        }
        
        return html
    }
    
    // ------------------------------------ Private methods ------------------------------------ //
    
    private func registerSystemExtensions()
    {
        SWFView.extensions.registerSimpleTag("cachebuster") { (context) -> String in
            return "?time=" + String(Int(Date().timeIntervalSince1970))
        }
    }
}
