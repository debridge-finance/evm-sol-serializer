// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../library/DeBridgeSolana.sol";

contract SimpleExample {
    using DeBridgeSolanaSerializer for DeBridgeSolana.ExternalInstruction;

    function serializeNativeExternalInstruction() external pure returns (bytes memory) {
        DeBridgeSolana.ExternalInstruction memory externalInstruction = DeBridgeSolana.ExternalInstruction({
            reward: 5000,
            expense: 10000,
            execute_policy: DeBridgeSolana.ExecutePolicy.Empty,
            pubkey_substitutions: getPubkeySubstitutionTuples(),
            data_substitutions: getDataSubstitutions(),
            instruction: DeBridgeSolana.Instruction({
                // [50; 32]
                program_id: 0x3232323232323232323232323232323232323232323232323232323232323232,
                accounts: getAccountMetas(),
                data: getSerializedInstructionData()
            })
        });

        return externalInstruction.serialize();
    }

    function getPubkeySubstitutionTuples() internal pure returns (DeBridgeSolana.PubkeySubstitutionTuple[] memory pss) {
        pss = new DeBridgeSolana.PubkeySubstitutionTuple[](2);
        pss[0] = DeBridgeSolana.PubkeySubstitutionTuple({
                u64: 0,
                data: DeBridgeSolanaPubkeySubstitutions.serialize(DeBridgeSolanaPubkeySubstitutions.SubmissionAuthWallet({
                    // [0u8; 32]
                    token_mint: 0x0000000000000000000000000000000000000000000000000000000000000000
                }))
            });


        pss[1] = getPubkeySubstitutionTuple_1();
    }

    function getPubkeySubstitutionTuple_1() internal pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
        DeBridgeSolanaPubkeySubstitutions.Seed[] memory seeds = new DeBridgeSolanaPubkeySubstitutions.Seed[](2);
        seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(uint8(1), uint8(2), uint8(3)));
        seeds[1] = DeBridgeSolanaPubkeySubstitutions.getSubmissionAuthSeed();

        return DeBridgeSolana.PubkeySubstitutionTuple({
                u64: 1,
                data: DeBridgeSolanaPubkeySubstitutions.serialize(DeBridgeSolanaPubkeySubstitutions.BySeeds({
                    // [1u8; 32]
                    program_id: 0x0101010101010101010101010101010101010101010101010101010101010101,
                    seeds: seeds,
                    bump: 255
                }))
            });
    }

    function getDataSubstitutions() internal pure returns (DeBridgeSolana.DataSubstitution[] memory dss) {
        dss = new DeBridgeSolana.DataSubstitution[](2);
        dss[0] = DeBridgeSolana.DataSubstitution({
            data: DeBridgeSolanaDataSubstitutions.serialize(DeBridgeSolanaDataSubstitutions.SubmissionAuthWalletAmount({
                account_index: 5100,
                offset: 5200,
                is_big_endian: true,
                subtraction: 10
            }))
        });

        dss[1] = DeBridgeSolana.DataSubstitution({
            data: DeBridgeSolanaDataSubstitutions.serialize(DeBridgeSolanaDataSubstitutions.SubmissionAuthWalletAmount({
                account_index: 6100,
                offset: 6300,
                is_big_endian: false,
                subtraction: 20
            }))
        });
    }

    function getAccountMetas() internal pure returns (DeBridgeSolana.AccountMeta[] memory ams) {
        ams = new DeBridgeSolana.AccountMeta[](1);
        ams[0] = DeBridgeSolana.AccountMeta({
            // [90; 32]
            pubkey: 0x5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a,
            is_signer: false,
            is_writable: false
        });
    }

    function getSerializedInstructionData() internal pure returns (bytes memory) {
        // [188; 10]
        bytes memory instructionData = new bytes(10);
        instructionData[0] = bytes1(uint8(188));
        instructionData[1] = bytes1(uint8(188));
        instructionData[2] = bytes1(uint8(188));
        instructionData[3] = bytes1(uint8(188));
        instructionData[4] = bytes1(uint8(188));
        instructionData[5] = bytes1(uint8(188));
        instructionData[6] = bytes1(uint8(188));
        instructionData[7] = bytes1(uint8(188));
        instructionData[8] = bytes1(uint8(188));
        instructionData[9] = bytes1(uint8(188));

        return instructionData;
    }
}
