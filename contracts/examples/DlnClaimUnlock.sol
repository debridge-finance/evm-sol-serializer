// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../library/DeBridgeSolana.sol";

contract DlnClaimUnlockExample {
    using DeBridgeSolanaSerializer for DeBridgeSolana.ExternalInstruction;

    // ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL
    bytes32 constant programId = 0x8C97258F4E2489F1BB3D1029148E0D830B5A1399DAFF1084048E7BD8DBE9F859;

    function serializeNativeExternalInstruction0() external pure returns (bytes memory) {
        DeBridgeSolana.ExternalInstruction memory externalInstruction = DeBridgeSolana.ExternalInstruction({
            reward: 0,
            expense: 2039280,
            execute_policy: DeBridgeSolana.ExecutePolicy.Empty,
            pubkey_substitutions: getPubkeySubstitutionTuples(),
            data_substitutions: getDataSubstitutions(),
            instruction: DeBridgeSolana.Instruction({
                // [50; 32]
                program_id: programId,
                accounts: getAccountMetas(),
                data: abi.encodePacked(bytes1(uint8(1)))
            })
        });

        return externalInstruction.serialize();
    }

    function getPubkeySubstitutionTuples() internal pure returns (DeBridgeSolana.PubkeySubstitutionTuple[] memory pss) {
        pss = new DeBridgeSolana.PubkeySubstitutionTuple[](1);
        pss[0] = getPubkeySubstitutionTuple_0();
    }

    function getPubkeySubstitutionTuple_0() internal pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
        DeBridgeSolanaPubkeySubstitutions.Seed[] memory seeds = new DeBridgeSolanaPubkeySubstitutions.Seed[](3);
        seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(bytes32(0xc8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8)));
        seeds[1] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(bytes32(0x06ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a9)));
        seeds[2] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(bytes32(0x6464646464646464646464646464646464646464646464646464646464646464)));

        return DeBridgeSolana.PubkeySubstitutionTuple({
                u64: 1,
                data: DeBridgeSolanaPubkeySubstitutions.serialize(DeBridgeSolanaPubkeySubstitutions.BySeeds({
                    program_id: programId,
                    seeds: seeds,
                    bump: 0
                }))
            });
    }

    function getDataSubstitutions() internal pure returns (DeBridgeSolana.DataSubstitution[] memory) {
    }

    function getAccountMetas() internal pure returns (DeBridgeSolana.AccountMeta[] memory ams) {
        ams = new DeBridgeSolana.AccountMeta[](6);
        ams[0] = DeBridgeSolana.AccountMeta({
            // 2iBUASRfDHgEkuZ91Lvos5NxwnmiryHrNbWBfEVqHRQZ
            pubkey: 0x1968562FEF0AAB1B1D8F99D44306595CD4BA41D7CC899C007A774D23AD702FF6,
            is_signer: true,
            is_writable: true
        });
        ams[1] = DeBridgeSolana.AccountMeta({
            // BicJ4dmuWD3bfBrJyKKeqzczWDSGUepUpaKWmC6XRoJZ
            pubkey: 0x9F3D96F657370BF1DBB3313EFBA51EA7A08296AC33D77B949E1B62D538DB37F2,
            is_signer: false,
            is_writable: true
        });
        ams[2] = DeBridgeSolana.AccountMeta({
            // EWn7dE93GeQJu72WEkEmC5MZpm5FhiJzkcJEf1xpRdWP
            pubkey: 0xc8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8,
            is_signer: false,
            is_writable: false
        });
        ams[3] = DeBridgeSolana.AccountMeta({
            // 7ktZK7a28phex41kcsct6YBHQt38MMezsoecq1UuiKFh
            pubkey: 0x6464646464646464646464646464646464646464646464646464646464646464,
            is_signer: false,
            is_writable: false
        });
        ams[4] = DeBridgeSolana.AccountMeta({
            // 11111111111111111111111111111111
            pubkey: 0x0000000000000000000000000000000000000000000000000000000000000000,
            is_signer: false,
            is_writable: false
        });
        ams[5] = DeBridgeSolana.AccountMeta({
            // TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA
            pubkey: 0x06ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a9,
            is_signer: false,
            is_writable: false
        });
    }
}
