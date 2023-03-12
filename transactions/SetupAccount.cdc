import FungibleToken from 0x01

// This transaction configures an account to store and receive tokens defined by
// the FungibleToken contract
transaction {
    prepare(acct: AuthAccount) {
        // Create a new empty Vault object
        let vaultA <- FungibleToken.createEmptyVault()

        // Store the vault in the account storage
        acct.save<@FungibleToken.Vault>(<-vaultA, to: /storage/MainVault)

        log("Empty Vault stored")

        // Create a public receiver capability to the Vault
        let ReceiverRef = acct.link<&FungibleToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/MainReceiver, target: /storage/MainVault)

        log("References created")
    }

    post {
        getAccount(0x02).getCapability<&FungibleToken.Vault{FungibleToken.Receiver}>(/public/MainReceiver)
                        .check():
                        "Vault Receiver Reference was not created correctly"
    }
}