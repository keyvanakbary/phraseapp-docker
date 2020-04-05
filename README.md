# Phraseapp Docker

Run [Phraseapp CLI](https://phrase.com/cli) in a Docker container.

## Usage

    docker run --rm -it -v $PWD:/code -e UID=$(id -u) keyvanakbary/phraseapp phraseapp init
