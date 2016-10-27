import Darwin
import SwiftCLI

CLI.setup(name: "flock")

CLI.router = DefaultRouter(fallbackCommand: ForwardCommand())

CLI.register(command: InitCommand())
CLI.register(command: BuildCommand())
CLI.register(command: AddEnvironmentCommand())
CLI.register(command: CreateTaskCommand())

CLI.alias(from: "-h", to: "")
CLI.alias(from: "help", to: "")
CLI.alias(from: "version", to: "")

exit(CLI.go())
