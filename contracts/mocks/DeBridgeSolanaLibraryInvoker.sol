// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.0;

import '../library/DeBridgeSolana.sol';

contract DeBridgeSolanaLibraryInvoker {
  using DeBridgeSolanaSerializer for DeBridgeSolana.ExternalInstruction;

  function serializeArbitrarySeed(bytes memory vec) public pure returns (bytes memory) {
    return DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(vec);
  }

  function serializeSubmissionAuthSeed() public pure returns (bytes memory) {
    return DeBridgeSolanaPubkeySubstitutions.getSubmissionAuthSeed();
  }

  function serializeSubmissionAuthWallet(
    DeBridgeSolanaPubkeySubstitutions.SubmissionAuthWallet memory submissionAuthWallet
  ) public pure returns (bytes memory data) {
    return DeBridgeSolanaPubkeySubstitutions.serialize(submissionAuthWallet);
  }

  function serializeSubmissionAuthWalletAmount(
    DeBridgeSolanaDataSubstitutions.SubmissionAuthWalletAmount memory submissionAuthWalletAmount
  ) public pure returns (bytes memory data) {
    return DeBridgeSolanaDataSubstitutions.serialize(submissionAuthWalletAmount);
  }

  function serializePubkeySubstitutionTuples(
    DeBridgeSolana.PubkeySubstitutionTuple[] memory pss
  ) public pure returns (bytes memory data) {
    return DeBridgeSolanaSerializer.serialize(pss);
  }

  function serializeDataSubstitutions(
    DeBridgeSolana.DataSubstitution[] memory dss
  ) public pure returns (bytes memory data) {
    return DeBridgeSolanaSerializer.serialize(dss);
  }

  function serializeBySeeds(
    DeBridgeSolanaPubkeySubstitutions.BySeeds memory bySeeds
  ) public pure returns (bytes memory data) {
    return DeBridgeSolanaPubkeySubstitutions.serialize(bySeeds);
  }

  function serializeAccountsMeta(
    DeBridgeSolana.AccountMeta memory accountsMeta
  ) public pure returns (bytes memory data) {
    return DeBridgeSolanaSerializer.serialize(accountsMeta);
  }

  function serializeInstruction(
    DeBridgeSolana.Instruction memory instruction
  ) public pure returns (bytes memory data) {
    return DeBridgeSolanaSerializer.serialize(instruction);
  }

  function serializeExternalInstruction(
    DeBridgeSolana.ExternalInstruction memory externalInstruction
  ) public pure returns (bytes memory) {
    return externalInstruction.serialize();
  }
}
