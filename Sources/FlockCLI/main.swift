import SwiftCLI

let flock = CLI(name: "flock", version: "0.0.1")

flock.parser = Parser(router: Router())
flock.helpMessageGenerator = HelpMessageGenerator()

flock.commands = [
    InitCommand(),
    ListCommand(),
    CleanCommand()
]

flock.goAndExit()
