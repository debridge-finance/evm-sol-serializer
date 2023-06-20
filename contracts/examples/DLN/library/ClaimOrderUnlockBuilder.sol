// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.0;

import '../../../library/DeBridgeSolana.sol';
import './Base.sol';

library DlnClaimOrderUnlockBuilder {
  using DeBridgeSolanaSerializer for DeBridgeSolana.ExternalInstruction;

  // dln_src::State::SEED = [83,84,65,84,69]
  bytes5 private constant dln_src_State_SEED = 0x5354415445;

  // dln_src::FeeLedger::SEED = [70,69,69,32,76,69,68,71,69,82]
  bytes10 private constant dln_src_FeeLedger_SEED = 0x464545204c4544474552;

  // dln_src::FeeLedger::WALLET_SEED = [70,69,69,95,76,69,68,71,69,82,95,87,65,76,76,69,84]
  bytes17 private constant dln_src_FeeLedger_WALLET_SEED = 0x4645455f4c45444745525f57414c4c4554;

  // dln_src::GiveOrderState::SEED = [71,73,86,69,95,79,82,68,69,82,95,83,84,65,84,69]
  bytes16 private constant dln_src_GiveOrderState_SEED = 0x474956455f4f524445525f5354415445;

  // anchor_spl::token::ID = [6,221,246,225,215,101,161,147,217,203,225,70,206,235,121,172,28,180,133,237,95,91,55,145,58,140,245,133,126,255,0,169]
  bytes32 private constant anchor_spl_token_ID =
    0x06ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a9;

  // dln_src::GiveOrderState::WALLET_SEED = [71,73,86,69,95,79,82,68,69,82,95,87,65,76,76,69,84,]
  bytes17 private constant dln_src_GiveOrderState_WALLET_SEED =
    0x474956455f4f524445525f57414c4c4554;

  // dln_src::AuthorizedNativeSender::SEED = [65,85,84,72,79,82,73,90,69,68,95,78,65,84,73,86,69,95,83,69,78,68,69,82]
  bytes24 private constant dln_src_AuthorizedNativeSender_SEED =
    0x415554484f52495a45445f4e41544956455f53454e444552;

  // [89,81,180,79,142,144,66,251]
  bytes8 private constant dln_unlock_discriminator = 0x5951b44f8e9042fb;

  uint64 private constant expense = 0;

  function getClaimOrderUnlockExternalInstruction(
    uint64 reward,
    bytes32 actionBeneficiary,
    uint256 orderId,
    uint256 orderTakeChainId,
    bytes32 orderGiveTokenAddress
  ) internal pure returns (DeBridgeSolana.ExternalInstruction memory) {
    return
      DeBridgeSolana.ExternalInstruction({
        reward: reward,
        expense: expense,
        execute_policy: DeBridgeSolana.ExecutePolicy.Empty,
        pubkey_substitutions: getPubkeySubstitutionTuples(
          actionBeneficiary,
          orderId,
          orderTakeChainId,
          orderGiveTokenAddress
        ),
        data_substitutions: getDataSubstitutions(),
        instruction: DeBridgeSolana.Instruction({
          program_id: DlnBase.dln_src_ID,
          accounts: getAccountMetas(),
          data: getInstructionData(orderId)
        })
      });
  }

  function getSerializedClaimOrderUnlockExternalInstruction(
    uint64 reward,
    bytes32 actionBeneficiary,
    uint256 orderId,
    uint256 orderTakeChainId,
    bytes32 orderGiveTokenAddress
  ) internal pure returns (bytes memory) {
    return
      getClaimOrderUnlockExternalInstruction(
        reward,
        actionBeneficiary,
        orderId,
        orderTakeChainId,
        orderGiveTokenAddress
      ).serialize();
  }

  function getInstructionData(uint256 orderId) private pure returns (bytes memory) {
    return abi.encodePacked(dln_unlock_discriminator, orderId);
  }

  function getPubkeySubstitutionTuples(
    bytes32 actionBeneficiary,
    uint256 orderId,
    uint256 orderTakeChainId,
    bytes32 orderGiveTokenAddress
  ) private pure returns (DeBridgeSolana.PubkeySubstitutionTuple[] memory pss) {
    pss = new DeBridgeSolana.PubkeySubstitutionTuple[](7);
    pss[0] = getPubkeySubstitutionTuple_0();
    pss[1] = getPubkeySubstitutionTuple_1();
    pss[2] = getPubkeySubstitutionTuple_2(orderGiveTokenAddress);
    pss[3] = getPubkeySubstitutionTuple_3(orderId);
    pss[4] = getPubkeySubstitutionTuple_4(actionBeneficiary, orderGiveTokenAddress);
    pss[5] = getPubkeySubstitutionTuple_5(orderId);
    pss[6] = getPubkeySubstitutionTuple_6(orderTakeChainId);
  }

  function getPubkeySubstitutionTuple_0()
    private
    pure
    returns (DeBridgeSolana.PubkeySubstitutionTuple memory)
  {
    bytes[] memory seeds = new bytes[](1);
    seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(
      abi.encodePacked(dln_src_State_SEED)
    );

    return
      DeBridgeSolana.PubkeySubstitutionTuple({
        u64: 2,
        data: DeBridgeSolanaPubkeySubstitutions.serialize(
          DeBridgeSolanaPubkeySubstitutions.BySeeds({
            program_id: DlnBase.dln_src_ID,
            seeds: seeds,
            bump: 0
          })
        )
      });
  }

  function getPubkeySubstitutionTuple_1()
    private
    pure
    returns (DeBridgeSolana.PubkeySubstitutionTuple memory)
  {
    bytes[] memory seeds = new bytes[](1);
    seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(
      abi.encodePacked(dln_src_FeeLedger_SEED)
    );

    return
      DeBridgeSolana.PubkeySubstitutionTuple({
        u64: 3,
        data: DeBridgeSolanaPubkeySubstitutions.serialize(
          DeBridgeSolanaPubkeySubstitutions.BySeeds({
            program_id: DlnBase.dln_src_ID,
            seeds: seeds,
            bump: 0
          })
        )
      });
  }

  function getPubkeySubstitutionTuple_2(
    bytes32 orderGiveTokenAddress
  ) private pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
    bytes[] memory seeds = new bytes[](2);
    seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(
      abi.encodePacked(dln_src_FeeLedger_WALLET_SEED)
    );
    seeds[1] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(
      abi.encodePacked(orderGiveTokenAddress)
    );

    return
      DeBridgeSolana.PubkeySubstitutionTuple({
        u64: 4,
        data: DeBridgeSolanaPubkeySubstitutions.serialize(
          DeBridgeSolanaPubkeySubstitutions.BySeeds({
            program_id: DlnBase.dln_src_ID,
            seeds: seeds,
            bump: 0
          })
        )
      });
  }

  function getPubkeySubstitutionTuple_3(
    uint256 orderId
  ) private pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
    bytes[] memory seeds = new bytes[](2);
    seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(
      abi.encodePacked(dln_src_GiveOrderState_SEED)
    );
    seeds[1] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(orderId));

    return
      DeBridgeSolana.PubkeySubstitutionTuple({
        u64: 6,
        data: DeBridgeSolanaPubkeySubstitutions.serialize(
          DeBridgeSolanaPubkeySubstitutions.BySeeds({
            program_id: DlnBase.dln_src_ID,
            seeds: seeds,
            bump: 0
          })
        )
      });
  }

  function getPubkeySubstitutionTuple_4(
    bytes32 actionBeneficiary,
    bytes32 orderGiveTokenAddress
  ) private pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
    bytes[] memory seeds = new bytes[](3);
    seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(
      abi.encodePacked(actionBeneficiary)
    );
    seeds[1] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(
      abi.encodePacked(anchor_spl_token_ID)
    );
    seeds[2] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(
      abi.encodePacked(orderGiveTokenAddress)
    );

    return
      DeBridgeSolana.PubkeySubstitutionTuple({
        u64: 7,
        data: DeBridgeSolanaPubkeySubstitutions.serialize(
          DeBridgeSolanaPubkeySubstitutions.BySeeds({
            program_id: DlnBase.spl_associated_token_account_ID,
            seeds: seeds,
            bump: 0
          })
        )
      });
  }

  function getPubkeySubstitutionTuple_5(
    uint256 orderId
  ) private pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
    bytes[] memory seeds = new bytes[](2);
    seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(
      abi.encodePacked(dln_src_GiveOrderState_WALLET_SEED)
    );
    seeds[1] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(orderId));

    return
      DeBridgeSolana.PubkeySubstitutionTuple({
        u64: 9,
        data: DeBridgeSolanaPubkeySubstitutions.serialize(
          DeBridgeSolanaPubkeySubstitutions.BySeeds({
            program_id: DlnBase.dln_src_ID,
            seeds: seeds,
            bump: 0
          })
        )
      });
  }

  function getPubkeySubstitutionTuple_6(
    uint256 orderTakeChainId
  ) private pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
    bytes[] memory seeds = new bytes[](2);
    seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(
      abi.encodePacked(dln_src_AuthorizedNativeSender_SEED)
    );
    seeds[1] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(
      abi.encodePacked(orderTakeChainId)
    );

    return
      DeBridgeSolana.PubkeySubstitutionTuple({
        u64: 11,
        data: DeBridgeSolanaPubkeySubstitutions.serialize(
          DeBridgeSolanaPubkeySubstitutions.BySeeds({
            program_id: DlnBase.dln_src_ID,
            seeds: seeds,
            bump: 0
          })
        )
      });
  }

  function getDataSubstitutions() private pure returns (DeBridgeSolana.DataSubstitution[] memory) {}

  function getAccountMetas() private pure returns (DeBridgeSolana.AccountMeta[] memory ams) {
    ams = new DeBridgeSolana.AccountMeta[](13);
    ams[0] = DeBridgeSolana.AccountMeta({
      // 7cu34CRu47UZKLRHjt9kFPhuoYyHCzAafGiGWz83GNFs
      pubkey: 0x62584959deb8a728a91cebdc187b545d920479265052145f31fb80c73fac5aea,
      is_signer: false,
      is_writable: false
    });
    ams[1] = DeBridgeSolana.AccountMeta({
      // 2iBUASRfDHgEkuZ91Lvos5NxwnmiryHrNbWBfEVqHRQZ
      pubkey: 0x1968562fef0aab1b1d8f99d44306595cd4ba41d7cc899c007a774d23ad702ff6,
      is_signer: true,
      is_writable: true
    });
    ams[2] = DeBridgeSolana.AccountMeta({
      // HJEPgYkbqjetrphNHG2W33SjG9mB4PrXorW358MzfggY
      pubkey: 0xf2250182dbb654414c597aa68671aedf4c362cea471a83827874f7e5fc5cc231,
      is_signer: false,
      is_writable: true
    });
    ams[3] = DeBridgeSolana.AccountMeta({
      // 6p6RCUtoXDvrwqx9AJmyM3wCFd9nDvMaLs3Fwif6QeXH
      pubkey: 0x565adba0294c79178f6d8f740ad91b150a16f3664ac6b662396196aa74a366f8,
      is_signer: false,
      is_writable: true
    });
    ams[4] = DeBridgeSolana.AccountMeta({
      // Ei4imuk2xD5NVJvc1LMCZUTrbA4vdMMjyxV1ufAAScF2
      pubkey: 0xcbacf3203fa78ab924a40edaea6df7c61852ed302f39bc5a5570a13a0230f8b1,
      is_signer: false,
      is_writable: true
    });
    ams[5] = DeBridgeSolana.AccountMeta({
      // Sysvar1nstructions1111111111111111111111111
      pubkey: 0x06a7d517187bd16635dad40455fdc2c0c124c68f215675a5dbbacb5f08000000,
      is_signer: false,
      is_writable: false
    });
    ams[6] = DeBridgeSolana.AccountMeta({
      // FE8SA3YT4Mo5dBwLUXPuwipUztAn4gjbBpnTvFy9FFnq
      pubkey: 0xd36092a49b1e0128ac52dac1d2e12a9620c26355e6b0395f261f38573380100a,
      is_signer: false,
      is_writable: true
    });
    ams[7] = DeBridgeSolana.AccountMeta({
      // BicJ4dmuWD3bfBrJyKKeqzczWDSGUepUpaKWmC6XRoJZ
      pubkey: 0x9f3d96f657370bf1dbb3313efba51ea7a08296ac33d77b949e1b62d538db37f2,
      is_signer: false,
      is_writable: true
    });
    ams[8] = DeBridgeSolana.AccountMeta({
      // EWn7dE93GeQJu72WEkEmC5MZpm5FhiJzkcJEf1xpRdWP
      pubkey: 0xc8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8,
      is_signer: false,
      is_writable: true
    });
    ams[9] = DeBridgeSolana.AccountMeta({
      // 7n6ZP9exh5it1g7cWBNUv3CCSLnSys8dyfqPjcZSNw8Z
      pubkey: 0x64b38af2b249f349fb2d575069b8f66db033e0d50a7ecac5be7178a9ca0d08e6,
      is_signer: false,
      is_writable: true
    });
    ams[10] = DeBridgeSolana.AccountMeta({
      // 7ktZK7a28phex41kcsct6YBHQt38MMezsoecq1UuiKFh
      pubkey: 0x6464646464646464646464646464646464646464646464646464646464646464,
      is_signer: false,
      is_writable: false
    });
    ams[11] = DeBridgeSolana.AccountMeta({
      // 2LoKkwgcfKPFzrPCeHHLvN7TKGfGkRA4j5qbQZNUKzvF
      pubkey: 0x13ee19b00dbd5580bc34492d838579bb743a2626308be4490dfa514d873e0234,
      is_signer: false,
      is_writable: false
    });
    ams[12] = DeBridgeSolana.AccountMeta({
      // TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA
      pubkey: 0x06ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a9,
      is_signer: false,
      is_writable: false
    });
  }
}
