import SwiftCLI

CLI.setup(name: "flock")

CLI.router = DefaultRouter(defaultCommand: ForwardCommand())

CLI.registerCommand(InitCommand())
CLI.registerCommand(BuildCommand())
CLI.registerCommand(AddEnvironmentCommand())

CLI.go()
