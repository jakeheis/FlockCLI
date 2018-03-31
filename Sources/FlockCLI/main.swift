import SwiftCLI

let flock = CLI(name: "flock", version: "0.0.1")

flock.router = Router()
flock.optionRecognizer = OptionRecognizer()
flock.helpMessageGenerator = HelpMessageGenerator()

flock.commands = [
    InitCommand(),
    ListCommand(),
    CleanCommand()
]

flock.goAndExit()
