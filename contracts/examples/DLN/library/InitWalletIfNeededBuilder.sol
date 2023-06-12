// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../../../library/DeBridgeSolana.sol";
import "./Base.sol";

library DlnInitWalletIfNeededBuilder {
    using DeBridgeSolanaSerializer for DeBridgeSolana.ExternalInstruction;

    bytes32 private constant TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA = 0x06ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a9;
    bytes32 private constant bs58_2iBUASRfDHgEkuZ91Lvos5NxwnmiryHrNbWBfEVqHRQZ = 0x1968562FEF0AAB1B1D8F99D44306595CD4BA41D7CC899C007A774D23AD702FF6;
    bytes32 private constant BicJ4dmuWD3bfBrJyKKeqzczWDSGUepUpaKWmC6XRoJZ = 0x9F3D96F657370BF1DBB3313EFBA51EA7A08296AC33D77B949E1B62D538DB37F2;
    bytes32 private constant bs58_11111111111111111111111111111111 = 0x0000000000000000000000000000000000000000000000000000000000000000;
    uint64 private constant expense = 2039280;

    function getInitWalletIfNeededExternalInstruction(uint64 reward, bytes32 actionBeneficiary, bytes32 orderGiveTokenAddress) internal pure returns (DeBridgeSolana.ExternalInstruction memory) {
        return DeBridgeSolana.ExternalInstruction({
            reward: reward,
            expense: expense,
            execute_policy: DeBridgeSolana.ExecutePolicy.Empty,
            pubkey_substitutions: getPubkeySubstitutionTuples(actionBeneficiary, orderGiveTokenAddress),
            data_substitutions: getDataSubstitutions(),
            instruction: DeBridgeSolana.Instruction({
                program_id: DlnBase.spl_associated_token_account_ID,
                accounts: getAccountMetas(actionBeneficiary, orderGiveTokenAddress),
                data: abi.encodePacked(bytes1(uint8(1)))
            })
        });
    }

    function getSerializedInitWalletIfNeededExternalInstruction(uint64 reward, bytes32 actionBeneficiary, bytes32 orderGiveTokenAddress) internal pure returns (bytes memory) {
        return getInitWalletIfNeededExternalInstruction(reward, actionBeneficiary, orderGiveTokenAddress).serialize();
    }

    function getPubkeySubstitutionTuples(bytes32 actionBeneficiary, bytes32 orderGiveTokenAddress) private pure returns (DeBridgeSolana.PubkeySubstitutionTuple[] memory pss) {
        pss = new DeBridgeSolana.PubkeySubstitutionTuple[](1);
        pss[0] = getPubkeySubstitutionTuple_0(actionBeneficiary, orderGiveTokenAddress);
    }

    function getPubkeySubstitutionTuple_0(bytes32 actionBeneficiary, bytes32 orderGiveTokenAddress) private pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
        DeBridgeSolanaPubkeySubstitutions.Seed[] memory seeds = new DeBridgeSolanaPubkeySubstitutions.Seed[](3);
        seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(actionBeneficiary));
        seeds[1] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA));
        seeds[2] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(orderGiveTokenAddress));

        return DeBridgeSolana.PubkeySubstitutionTuple({
                u64: 1,
                data: DeBridgeSolanaPubkeySubstitutions.serialize(DeBridgeSolanaPubkeySubstitutions.BySeeds({
                    program_id: DlnBase.spl_associated_token_account_ID,
                    seeds: seeds,
                    bump: 0
                }))
            });
    }

    function getDataSubstitutions() private pure returns (DeBridgeSolana.DataSubstitution[] memory) {
    }

    function getAccountMetas(bytes32 actionBeneficiary, bytes32 orderGiveTokenAddress) private pure returns (DeBridgeSolana.AccountMeta[] memory ams) {
        ams = new DeBridgeSolana.AccountMeta[](6);

        // Pubkey Auth Placeholder, constant
        ams[0] = DeBridgeSolana.AccountMeta({
            pubkey: bs58_2iBUASRfDHgEkuZ91Lvos5NxwnmiryHrNbWBfEVqHRQZ,
            is_signer: true,
            is_writable: true
        });

        // Can be any - not important, will be replaced by substituion later
        ams[1] = DeBridgeSolana.AccountMeta({
            pubkey: BicJ4dmuWD3bfBrJyKKeqzczWDSGUepUpaKWmC6XRoJZ,
            is_signer: false,
            is_writable: true
        });

        // Input Param
        ams[2] = DeBridgeSolana.AccountMeta({
            pubkey: actionBeneficiary,
            is_signer: false,
            is_writable: false
        });

        // Input Param
        ams[3] = DeBridgeSolana.AccountMeta({
            pubkey: orderGiveTokenAddress,
            is_signer: false,
            is_writable: false
        });

        // Constant
        ams[4] = DeBridgeSolana.AccountMeta({
            pubkey: bs58_11111111111111111111111111111111,
            is_signer: false,
            is_writable: false
        });

        // Constant (at this stage, will be able to take two values later)
        ams[5] = DeBridgeSolana.AccountMeta({
            pubkey: TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA,
            is_signer: false,
            is_writable: false
        });
    }
}
