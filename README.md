# FlockCLI

The CLI used to interact with [Flock](https://github.com/jakeheis/Flock).

# Installation
### Homebrew
```bash
brew install jakeheis/repo/flock
```
### Manual
```bash
git clone https://github.com/jakeheis/FlockCLI
cd FlockCLI
swift build -c release
ln -s .build/release/FlockCLI /usr/bin/local/flock
```
# Commands
#### flock init          
Initializes Flock in the current directory. See [Flock's README](https://github.com/jakeheis/Flock/blob/master/README.md#init) for more info about what exactly this command does.
#### flock clean
Cleans Flock's build directory in the current project by removing `.flock/.build`. Shouldn't need to be called often.
#### flock help
Prints help information
#### flock version
Prints the current version of Flock
#### flock \<task\>
Execute the given task. See [Flock's README](https://github.com/jakeheis/Flock/blob/master/README.md#running-tasks) for more info about what exactly this command does.
