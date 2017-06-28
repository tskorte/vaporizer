//
//  ShellHelper.swift
//  HelloVapor
//
//  Created by Karl Kristian Forfang on 10.06.2017.
//
//

import Foundation
import SwiftShell



public struct ShellHelper {
    public static func shell(launchPath: String, arguments: [String] = []){
        let command = runAsync("sh /home/vaporizer/deployScript.sh", ["-p"]).onCompletion{ command in
            print("Command finished")
        }
        try! command.finish()
    }
    
    static func deploy(){
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = ["mkdir buildVaporizer"]
        process.launch()
    }
    
    static func build(){
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = ["cd /home/"]
        process.launch()
    }
}
