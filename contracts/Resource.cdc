// Resources can be used to create a secure model of digital ownership
pub contract HelloWorld {
    pub resource HelloAsset {
        // A transaction can call this function to get the message from the resource
        pub fun hello(): String {
            return "Hello, World!";
        }
    }

    init() {
        // Create built-in function to create new instance of the resource
        let newHello <- create HelloAsset()

        // Can do anything in init function, include accessing the storage
        // of the account that this contract is deployed to

        // Create hello world resource and store in the private account
        // storage by specifying a custom path
        self.account.save(<-newHello, to: /storage/Hello)

        log("HelloAsset created and stored")
    }
}
