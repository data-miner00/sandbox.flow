## Resource

- Composite type that has it's own defined fields and functions - similar to a struct
- are a new paradigm for asset ownership

Instead of representing ownership in a central ledger sc, each account owns a resource object in their account storage that records the number of tokens they own

| Account 0x01    | Account 0x02    |
| --------------- | --------------- |
| resource object | resource object |
| - balance: 30.0 | - balance: 50.0 |
| - withdraw()    | - withdraw()    |
| - deposit()     | - deposit()     |

- Users interact w/ each other p2p (instead of interact w/ a central token contract)
- if users want to use these tokens, they instantiate a zero-balance copy of this resource in their account storage

When interacting w/ resources, use the

- `@` symbol, or the
- `<-` move operator

`@` is used for specifying a resource type

- for a(n): field, argument, return value

`<-` move operator identifies when a resource is used for a(n): assignment, parameter, return value

that it is moved to that **location** that the old location is invalidated.

This ensures that the resource can only ever exist in one place at one time.
