import HelloWorld from 0x02

// This transaction creates a new capability
// for the HelloAsset resource in storage
// and adds it to the account's public area.

// Other accounts and scripts can use this capability
// to create a reference to the private object to be ablle to
// access its fields and call its methods.

transaction {
    prepare(account: AuthAccount) {
        
        // Create a public capability by linking the capability to
        // a `target` object in account storage.
        // The capability allows access to the object through an
        // interface defined by the owner.
        // This does not check if the link is valid or if the target exists.
        // It just creates the capability.
        // The capability is created and stored at /public/Hello, and is
        // also returned from the function.
        let capability = account.link<&HelloWorld.HelloAsset>(/public/Hello, target: /storage/Hello)

        // Use the capability's borrow method to create new reference
        // to the object that the capability links to
        // We use optional chaining "??" to get the value because
        // the value we are accesssing is an optional. If the optional is nil,
        // the panic will happen with a descriptive error message
        let helloReference = capability!.borrow()
            ?? panic("Could not borrow a reference to the hello capability")

        // Call the hello function using the reference to the HelloAsset resource
        log(helloReference.hello())
    }
}