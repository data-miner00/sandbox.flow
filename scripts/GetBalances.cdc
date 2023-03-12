import FungibleToken from 0x01

pub fun main() {
    let acct1 = getAccount(0x01)
    let acct2 = getAccount(0x02)

    let acct1ReceiverRef = acct1.getCapability(/public/MainReceiver)
                            .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()
                            ?? panic("Could not borrow a reference to the acct1 receiver")
                            
    let acct2ReceiverRef = acct2.getCapability(/public/MainReceiver)
                            .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()
                            ?? panic("Could not borrow a reference to the acct1 receiver")

    log("Account 1 Balance")
    log(acct1ReceiverRef.balance)
    
    log("Account 2 Balance")
    log(acct2ReceiverRef.balance)
}