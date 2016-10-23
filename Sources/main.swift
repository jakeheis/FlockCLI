import Darwin
import SwiftCLI

CLI.setup(name: "flock")

CLI.router = DefaultRouter(fallbackCommand: ForwardCommand())

CLI.register(command: InitCommand())
CLI.register(command: BuildCommand())
CLI.register(command: AddEnvironmentCommand())

exit(CLI.go())
