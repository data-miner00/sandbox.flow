import FungibleToken from 0x01

// This transaction mints tokens and deposits them into account 2'a vault
transaction {
    // local variable for storing the reference to the minter resource
    let mintingRef: &FungibleToken.VaultMinter

    // Local variable for storing the reference to the Vault of
    // the account that will receive the newly minted tokens
    var receiver: Capability<&FungibleToken.Vault{FungibleToken.Receiver}>

    prepare(acct: AuthAccount) {
        // Borrow a reference to the stored, private minter resource
        self.mintingRef = acct.borrow<&FungibleToken.VaultMinter>(from: /storage/MainMinter)
            ?? panic("Could not borrow a reference to the minter")

        // Get the public account object for account 0x02
        let recipient = getAccount(0x02)

        // Get their public receiver capability
        self.receiver = recipient.getCapability<&FungibleToken.Vault{FungibleToken.Receiver}>(/public/MainReceiver)
    }

    execute {
        // Mint 30 tokens and deposit them to the recipient's Vault
        self.mintingRef.mintTokens(amount: 30.0, recipient: self.receiver)

        log("30 tokens minted and deposited to account 0x02")
    }
}
