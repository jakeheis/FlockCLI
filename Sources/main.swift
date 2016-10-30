import Darwin
import SwiftCLI

CLI.setup(name: "flock", version: "0.0.1")

CLI.router = FlockRouter()
CLI.versionCommand = VersionCommand()
CLI.helpCommand = HelpCommand()

CLI.register(command: InitCommand())
CLI.register(command: BuildCommand())
CLI.register(command: UpdateCommand())
CLI.register(command: PullCommand())
CLI.register(command: CleanCommand())
CLI.register(command: CleanAllCommand())
CLI.register(command: AddEnvironmentCommand())
CLI.register(command: CreateTaskCommand())

CLI.alias(from: "-h", to: "--help")
CLI.alias(from: "-v", to: "--version")

exit(CLI.go())
