import HelloWorld from 0x01

transaction { // modify, read data from contract
    prepare(acc: AuthAccount) {}

    execute {
        log(HelloWorld.hello())
    }
}

// script read data, no need to pay fees
