## DeBridge EVM->Solana `ExternalInstruction` serializer

This package introduces a purposed library on Solidity for declaring and serializing deBridge's `ExternalInstruction` data struct, giving the ability to construct valid authentic calls to arbitrary Solana smart contracts on [supported EVM chains](https://docs.debridge.finance/contracts/mainnet-addresses) (Ethereum, etc), so they can be further [bridged](https://docs.debridge.finance/build-with-debridge/lifecycle-of-a-cross-chain-call)  to Solana through the [deBridge](https://debridge.finance/) generic messaging and cross-chain interoperability protocol.


## “Explain like I am not familiar with Solana”

In the world of Ethereum Virtual Machine (EVM), the call of a function of an arbitrary smart contract may be encoded into a hexadecimal string. This string is known as the [`call data`](https://docs.soliditylang.org/en/latest/internals/layout_in_calldata.html) and consists of a four bytes selector (representing the target function signature) and encoded argument values. For example, encoding a call to the `balanceOf(address)` function with the `0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045` address as the first argument value would results the following string:

```
0x70a08231000000000000000000000000d8da6bf26964af9d7eed9e03e53415d37aa96045
  |       |-- encoded argument values ------------------------------------
  |
  \
   four-byte selector
```

To facilitate cross-chain communication, deBridge's [`deBridgeGate.sendMessage()`](https://github.com/debridge-finance/debridge-contracts-v1/blob/main/contracts/interfaces/IDeBridgeGate.sol#L100) accepts the address of a smart contract to call, and the call data to use for such call:

```sol
deBridgeGate.sendMessage{value: _executionFee}(
    56, // BNB Chain ID
    contractAddress, // contract to call on BNB Chain upon message arrival
    callData // call data to use for the call
);
```

However, smart contracts on the Solana blockchain are organized differently. That's why the `deBridgeGate` smart contract residing on Solana expects a call data that represents a custom complex data struct serialized in a specific way (serde+bincode, *if you are interested*). The name of this custom data struct is `ExternalInstruction`:

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

Its complete definition in Rust can be found in [ExternalInstruction.rs](./spec/ExternalInstruction.rs). The example of declaring the `ExternalInstruction` data struct with values in Rust can be found in the [example.rs](./spec/example.rs).

### So, what's this?

The given library your are looking at provides **a full featured implementation of the `ExternalInstruction` data struct and its serializer on Solidity**, giving the ability to **construct valid authentic calls** to arbitrary Solana smart contracts on [supported EVM chains](https://docs.debridge.finance/contracts/mainnet-addresses) (Ethereum, etc), so they can be further [bridged](https://docs.debridge.finance/build-with-debridge/lifecycle-of-a-cross-chain-call) to Solana through the [deBridge](https://debridge.finance/) generic messaging and cross-chain interoperability protocol.


## Getting started

Start with inspecting the definition of the `ExternalInstruction` struct inside the [`DeBridgeSolana` library](./contracts/library/DeBridgeSolana.sol).

Next, look at the [`BasicExample` smart contract](./contracts/examples/Basic.sol) which is straightforward PoC example of preparing the `ExternalInstruction` struct with the given values on-chain.

Finally, inspect the [`DlnBuilder` library](./contracts/examples/DLN/library/Builder.sol) which is the example of a production-grade library used in the wild by [DLN.trade](https://dln.trade/), a high performance cross-chain exchange, for cross-chain communication. The `DlnBuilder` library uses `DeBridgeSolana` library under the hood to construct a set of two serialized `ExternalInstruction`s to be sent to Solana blockchain.

## Caveat

This library takes responsibility for the correct packaging of the data struct for transmission. It is a developers' responsibility to prepare values to be included in the data struct, and ensure these values are correct.

## License

All smart contracts are released under LGPL-3.0 by deBridge.