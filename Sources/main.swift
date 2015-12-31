import SwiftCLI

CLI.setup(name: "flock")

CLI.registerCommand(InitCommand())

CLI.go()
