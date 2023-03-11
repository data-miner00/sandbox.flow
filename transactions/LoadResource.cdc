import HelloWorld from 0x02

transaction {

    prepare(acct: AuthAccount) {

        // load the resource from storage, specifying the type to load it as
        // and the path where it is stored
        let helloResource <- acct.load<@HelloWorld.HelloAsset>(from: /storage/Hello)

        // Use optional chaining (?) as value in storage may or may not exist
        log(helloResource?.hello())

        // Put the resource back in storage at the same spot
        // Use the force-unwrap operator `!` to get value out of optional.
        // It aborts if the optional is nil
        acct.save(<-helloResource!, to: /storage/Hello)
    }
}
