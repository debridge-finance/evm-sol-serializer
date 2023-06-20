// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.0;

/// @author deBridge
library DeBridgeSolana {
  struct ExternalInstruction {
    uint64 reward;
    uint64 expense;
    ExecutePolicy execute_policy;
    PubkeySubstitutionTuple[] pubkey_substitutions;
    DataSubstitution[] data_substitutions;
    Instruction instruction;
  }

  enum ExecutePolicy {
    Empty,
    MandatoryBlock
  }

  struct PubkeySubstitutionTuple {
    uint64 u64;
    /// @dev one of the following structs serialized through the `DeBridgeSolanaPubkeySubstitutions.serialize()` method:
    ///    * `DeBridgeSolanaPubkeySubstitutions.SubmissionAuthWallet`
    ///    * `DeBridgeSolanaPubkeySubstitutions.BySeeds`
    bytes data;
  }

  struct DataSubstitution {
    /// @dev one of the following structs serialized through the `DeBridgeSolanaDataSubstitutions.serialize()` method:
    ///    * `DeBridgeSolanaDataSubstitutions.SubmissionAuthWalletAmount`
    bytes data;
  }

  struct AccountMeta {
    bytes32 pubkey;
    bool is_writable;
    bool is_signer;
  }

  struct Instruction {
    bytes32 program_id;
    AccountMeta[] accounts;
    /// @dev arbitrary value
    bytes data;
  }
}

library DeBridgeSolanaDataSubstitutions {
  using LittleEndianSerializer for uint64;

  struct SubmissionAuthWalletAmount {
    uint64 account_index;
    uint64 offset;
    bool is_big_endian;
    uint64 subtraction;
  }

  function serialize(
    SubmissionAuthWalletAmount memory submissionAuthWalletAmount
  ) internal pure returns (bytes memory data) {
    data = abi.encodePacked(
      hex'00000000',
      submissionAuthWalletAmount.account_index.uint64ToLittleEndian(),
      submissionAuthWalletAmount.offset.uint64ToLittleEndian(),
      submissionAuthWalletAmount.is_big_endian,
      submissionAuthWalletAmount.subtraction.uint64ToLittleEndian()
    );
  }
}

library DeBridgeSolanaPubkeySubstitutions {
  using LittleEndianSerializer for uint64;

  struct SubmissionAuthWallet {
    bytes32 token_mint;
  }

  struct BySeeds {
    bytes32 program_id;
    /// @dev Use the following shortcuts to retrieve properly encoded seed types:
    ///    * `DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed()`
    ///    * `DeBridgeSolanaPubkeySubstitutions.getSubmissionAuthSeed()`
    bytes[] seeds;
    uint8 bump;
  }

  function getArbitrarySeed(bytes memory vec) internal pure returns (bytes memory) {
    // require(vec.length <= (2**64 - 1), "U64");

    return abi.encodePacked(hex'00000000', uint64(vec.length).uint64ToLittleEndian(), vec);
  }

  function getSubmissionAuthSeed() internal pure returns (bytes memory) {
    return hex'01000000';
  }

  function serialize(
    SubmissionAuthWallet memory submissionAuthWallet
  ) internal pure returns (bytes memory data) {
    data = abi.encodePacked(hex'00000000', submissionAuthWallet.token_mint);
  }

  function serialize(BySeeds memory bySeeds) internal pure returns (bytes memory data) {
    data = abi.encodePacked(
      hex'01000000',
      bySeeds.program_id,
      serialize(bySeeds.seeds),
      bySeeds.bump == 0 ? abi.encodePacked(hex'00') : abi.encodePacked(hex'01', bySeeds.bump)
    );
  }

  function serialize(bytes[] memory seeds) internal pure returns (bytes memory data) {
    // require(seeds.length <= (2**64 - 1), "U64");

    data = abi.encodePacked(uint64(seeds.length).uint64ToLittleEndian());
    for (uint i = 0; i < seeds.length; i++) {
      data = abi.encodePacked(data, seeds[i]);
    }
  }
}

library DeBridgeSolanaSerializer {
  using LittleEndianSerializer for uint64;
  using LittleEndianSerializer for uint32;

  function serialize(
    DeBridgeSolana.ExternalInstruction memory ei
  ) internal pure returns (bytes memory data) {
    data = abi.encodePacked(
      ei.reward.uint64ToLittleEndian(),
      ei.expense == 0
        ? abi.encodePacked(hex'00')
        : abi.encodePacked(hex'01', ei.expense.uint64ToLittleEndian()),
      uint32(ei.execute_policy).uint32ToLittleEndian(),
      serialize(ei.pubkey_substitutions),
      serialize(ei.data_substitutions),
      serialize(ei.instruction)
    );
  }

  function serialize(bytes memory vec) internal pure returns (bytes memory data) {
    // require(vec.length <= (2**64 - 1), "U64");

    data = abi.encodePacked(uint64(vec.length).uint64ToLittleEndian(), vec);
  }

  function serialize(
    DeBridgeSolana.PubkeySubstitutionTuple[] memory pss
  ) internal pure returns (bytes memory data) {
    if (pss.length == 0) {
      data = hex'00';
    } else {
      // require(pss.length <= (2**64 - 1), "U64");

      data = abi.encodePacked(
        hex'01',
        uint64(pss.length).uint64ToLittleEndian(),
        // optimization!
        // inlining first element here saves 500 gas
        pss[0].u64.uint64ToLittleEndian(),
        pss[0].data
      );

      // beware! This loop starts at (1) rather than (0) because the first (zeroed) element
      // is being inlined onto previous abi.encodePacked() call. This saves 500 gas
      for (uint i = 1; i < pss.length; i++) {
        data = abi.encodePacked(data, pss[i].u64.uint64ToLittleEndian(), pss[i].data);
      }
    }
  }

  function serialize(
    DeBridgeSolana.DataSubstitution[] memory dss
  ) internal pure returns (bytes memory data) {
    if (dss.length == 0) {
      data = hex'00';
    } else {
      // require(dss.length <= (2**64 - 1), "U64");

      data = abi.encodePacked(hex'01', uint64(dss.length).uint64ToLittleEndian());

      for (uint i = 0; i < dss.length; i++) {
        data = abi.encodePacked(data, dss[i].data);
      }
    }
  }

  function serialize(
    DeBridgeSolana.Instruction memory i
  ) internal pure returns (bytes memory data) {
    data = abi.encodePacked(
      i.program_id,
      // inlining vector length here (rather than in
      // the underlying `serialize(DeBridgeSolana.AccountMeta[] memory ams)`) saves 500 gas
      uint64(i.accounts.length).uint64ToLittleEndian(),
      serialize(i.accounts),
      serialize(i.data)
    );
  }

  /// @dev This method is used for test case. Actual code is being inlined
  ///      onto `serialize(DeBridgeSolana.AccountMeta[] memory ams)`
  function serialize(
    DeBridgeSolana.AccountMeta memory am
  ) internal pure returns (bytes memory data) {
    data = abi.encodePacked(am.pubkey, am.is_signer, am.is_writable);
  }

  function serialize(
    DeBridgeSolana.AccountMeta[] memory ams
  ) internal pure returns (bytes memory data) {
    // require(ams.length <= (2**64 - 1), "U64");

    // inlining vector length on an higher level saves 500 gas {{{
    // data = abi.encodePacked(uint64(ams.length).uint64ToLittleEndian());
    // }}}

    for (uint i = 0; i < ams.length; i++) {
      data = abi.encodePacked(
        data,
        // inline call of `serialize(DeBridgeSolana.AccountMeta memory)` for optimization
        ams[i].pubkey,
        ams[i].is_signer,
        ams[i].is_writable
      );
    }
  }
}

library LittleEndianSerializer {
  function uint64ToLittleEndian(uint64 v) internal pure returns (uint64) {
    return _uint64ToLittleEndian(v);
  }

  function uint32ToLittleEndian(uint32 v) internal pure returns (uint32) {
    return _uint32ToLittleEndian(v);
  }

  function _uint64ToLittleEndian(uint64 x) internal pure returns (uint64 r) {
    assembly {
      for {
        let i := 0
      } lt(i, 8) {
        i := add(i, 1)
      } {
        r := or(shl(8, r), and(shr(mul(i, 8), x), 0xFF))
      }
    }
  }

  function _uint32ToLittleEndian(uint32 x) internal pure returns (uint32 r) {
    assembly {
      for {
        let i := 0
      } lt(i, 4) {
        i := add(i, 1)
      } {
        r := or(shl(8, r), and(shr(mul(i, 8), x), 0xFF))
      }
    }
  }
}
