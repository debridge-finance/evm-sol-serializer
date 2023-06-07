## DeBridge EVM->Solana `ExternalInstruction` serializer

This package introduces a set of structs and libraries written on Solidity, which are aimed to reflect and serialize deBridge's `ExternalInstruction` data structure for Solana on EVM chains.

## Explanation

To leverage cross-chain interoperability, DeBridge's gate smart contract on Solana is able to accept arbitrary instructions being bridged from any other supported blockchain through the `deBridgeGate` smart contract, and execute these instructions upon arrival. Such instructions are packed as a series of `ExternalInstruction` Rust struct.

This package provides a library on Solidity, that gives the ability to declare a compatible `ExternalInstruction` data struct using Solidity, and serialize this instruction so it gets accepted and correctly executed on Solana.

Here is a the definition of the `ExternalInstruction` in Rust:

```rust
pub struct ExternalInstruction {
    pub reward: Amount,
    pub expense: Option<Amount>,
    pub execute_policy: ExecutePolicy,
    pub pubkey_substitutions: Option<Vec<(u64, PubkeySubstitution)>>,
    pub data_substitutions: Option<Vec<DataSubstitution>>,
    pub instruction: Instruction,
}
```

(see [the complete set of types](./spec/ExternalInstruction.rs) involved in this struct)

And here is how it is declared in Solidity:

```solidity
struct ExternalInstruction {
    uint64 reward;
    uint64 expense;
    ExecutePolicy execute_policy;
    PubkeySubstitutionTuple[] pubkey_substitutions;
    DataSubstitution[] data_substitutions;
    Instruction instruction;
}
```

Consider looking at the [PoC example](./contracts/examples/Simple.sol) of how the instruction gets declared and serialized in Solidity.