import SwiftCLI

CLI.setup(name: "flock")

Router.Config.fallbackToDefaultCommand = true

CLI.defaultCommand = ForwardCommand()
CLI.helpCommand = nil

CLI.registerCommand(InitCommand())
CLI.registerCommand(UpdateCommand())
CLI.registerCommand(CleanCommand())
CLI.registerCommand(BuildCommand())

CLI.go()
