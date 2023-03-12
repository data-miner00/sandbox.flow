pub contract FungibleToken {
    // Total supply
    pub var totalSupply: UFix64

    // Provider
    // Interface that enforces the requirements for withdrawing
    // tokens from the implement type
    pub resource interface Provider {
        // Withdraw
        // Function that subtracts tokens from the owner's Vault
        // and returns a Vault resource (@Vault) with the removed tokens.
        pub fun withdraw(amount: UFix64): @Vault {
            post {
                result.balance == UFix64(amount):
                    "Withdrawal amount must be the same as the balance of the withdrawn Vault"
            }
        }
    }

    // Receiver
    // Interface that enforces the requirements for depositing
    // tokens into the implementing type
    pub resource interface Receiver {
        // deposit
        // Function that can be called to deposit tokens into the
        // implementing resource type
        pub fun deposit(from: @Vault)
    }

    // Balance
    // Interface that specifies a public `balance` field for the vault
    pub resource interface Balance {
        pub var balance: UFix64
    }

    // Vault
    // Each user stores an instance of only the Vault in their storage
    // The functions in the Vault are governed by the pre and post conditions
    // in the interfaces when they are called.
    // The checks happen at runtime whenever a function is called.
    pub resource Vault: Provider, Receiver, Balance {
        // keep track of total balance of the account's token
        pub var balance: UFix64

        init(balance: UFix64) {
            self.balance = balance
        }

        // withdraw
        pub fun withdraw(amount: UFix64): @Vault {
            self.balance = self.balance - amount
            return <-create Vault(balance: amount)
        }

        // deposit
        pub fun deposit(from: @Vault) {
            self.balance = self.balance + from.balance
            destroy from
        }
    }

    // createEmptyVault
    pub fun createEmptyVault(): @Vault {
        return <-create Vault(balance: 0.0)
    }

    // VaultMinter
    // Resource object that an admin can control to mint new tokens
    pub resource VaultMinter {
        // Function that mints new tokens and deposits into an account's vault
        // using their `Receiver` reference
        // We say `&AnyResource{Receiver}` to say that the recipient can be any resource
        // as long it implements the Receiver interface
        pub fun mintTokens(amount: UFix64, recipient: Capability<&AnyResource{Receiver}>) {
            let recipientRef = recipient.borrow()
                ?? panic("Could not borrow a receiver reference to the vault")

            FungibleToken.totalSupply = FungibleToken.totalSupply + UFix64(amount)
            recipientRef.deposit(from: <-create Vault(balance: amount))
        }
    }

    init() {
        self.totalSupply = 30.0

        // Create the vault with initial balance and put in storage
        // `account.save` saves an object to the specified path
        // The path is a literal path that consist of domain and identifier
        // The domain must be `storage` `private`, or `public`
        // the identifier can be of any name
        let vault <- create Vault(balance: self.totalSupply)
        self.account.save(<-vault, to: /storage/MainVault)

        // Create and new MintAndBurn resource and store it in account storage
        self.account.save(<-create VaultMinter(), to: /storage/MainMinter)

        // Create a private capability link for the Minter
        // Capabilities can be used to create temporary references to an object
        // so that callers can use the reference to access fields and functions
        // of the object

        // Capability is stored in the `/private/` domain, which is only
        // accessible by the owner of the account
        self.account.link<&VaultMinter>(/private/Minter, target: /storage/MainMinter)
    }
}
