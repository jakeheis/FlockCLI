import SwiftCLI

CLI.setup(name: "flock")

Router.Config.fallbackToDefaultCommand = true

CLI.defaultCommand = ForwardCommand()
CLI.helpCommand = nil
CLI.registerCommand(InitCommand())

CLI.go()
