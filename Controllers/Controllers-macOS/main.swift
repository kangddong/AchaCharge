//
//  main.swift
//  Controllers-macOS
//
//  Created by 강동영 on 6/27/24.
//

import Cocoa

func main() {
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate
    app.run()
}

main()
