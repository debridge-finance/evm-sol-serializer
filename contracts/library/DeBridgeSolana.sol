// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// import "hardhat/console.sol";


library DeBridgeSolana {
    using DeBridgeSolanaSerializer for ExternalInstruction;

    struct ExternalInstruction {
        uint64 reward;
        uint64 expense;
        ExecutePolicy execute_policy;
        PubkeySubstitutionTuple[] pubkey_substitutions;
        DataSubstitution[] data_substitutions;
        Instruction instruction;
    }

    enum ExecutePolicy {
        Empty, MandatoryBlock
    }

    struct PubkeySubstitutionTuple {
        uint64 u64;
        bytes data;
    }

    struct DataSubstitution {
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
        bytes data;
    }
}
library DeBridgeSolanaDataSubstitutions {
    using LittleEndianSerializer for uint64;
    struct SubmissionAuthWalletAmount {
        uint64 account_index;
        uint64 offset;
        bool is_big_endian;
        /// Subtraction from token account balane before replace
        uint64 subtraction;
    }

    function serialize(SubmissionAuthWalletAmount memory submissionAuthWalletAmount) internal pure returns (bytes memory data) {
        data =  abi.encodePacked(
            // bytes1(0), bytes1(0), bytes1(0), bytes1(0),
            hex"00000000",
            LittleEndianSerializer.reverseU64(submissionAuthWalletAmount.account_index),
            LittleEndianSerializer.reverseU64(submissionAuthWalletAmount.offset),
            submissionAuthWalletAmount.is_big_endian,// == true ?  bytes1(uint8(1)) : bytes1(0),
            LittleEndianSerializer.reverseU64(submissionAuthWalletAmount.subtraction)
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
        Seed[] seeds;
        uint8 bump;
    }

    struct Seed {
        bytes data;
    }

    function serialize(SubmissionAuthWallet memory submissionAuthWallet) internal pure returns (bytes memory data) {
        data = abi.encodePacked(
            // bytes1(0), bytes1(0), bytes1(0), bytes1(0),
            hex"00000000",
            submissionAuthWallet.token_mint);
    }

    function serialize(BySeeds memory bySeeds) internal pure returns (bytes memory data) {
        data = abi.encodePacked(
            bytes1(uint8(1)), bytes1(0), bytes1(0), bytes1(0),
            bySeeds.program_id,
            serialize(bySeeds.seeds),
            bySeeds.bump == 0 ? abi.encodePacked(hex"00") : abi.encodePacked(hex"01", bytes1(bySeeds.bump))
        );
    }

    function serialize(Seed[] memory seeds) internal pure returns (bytes memory data) {
        require(seeds.length <= (2**64 - 1), "U64");

        data = abi.encodePacked(LittleEndianSerializer.reverseU64(uint64(seeds.length)));
        for (uint i = 0; i < seeds.length; ++i) {
            data = abi.encodePacked(data, seeds[i].data);
        }
    }

    function getArbitrarySeed(bytes memory vec) internal pure returns (DeBridgeSolanaPubkeySubstitutions.Seed memory) {
        bytes memory data = abi.encodePacked(
            //bytes1(0), bytes1(0), bytes1(0), bytes1(0));
            hex"00000000",
            LittleEndianSerializer.reverseU64(uint64(vec.length)),
            vec);
        return DeBridgeSolanaPubkeySubstitutions.Seed({
            data: data
        });
    }

    function getSubmissionAuthSeed() internal pure returns (DeBridgeSolanaPubkeySubstitutions.Seed memory) {
        //bytes.concat(bytes1(uint8(1)), bytes1(0), bytes1(0), bytes1(0));
        bytes memory data = hex"01000000"; 

        return DeBridgeSolanaPubkeySubstitutions.Seed({
            data: data
        });
    }
}

library DeBridgeSolanaSerializer {
    using LittleEndianSerializer for uint64;
    using LittleEndianSerializer for uint32;

    function serialize(DeBridgeSolana.ExternalInstruction memory ei) internal pure returns (bytes memory data) {
        // console.log("serialize. Gas left at the start: %s", gasleft());
        // console.log("pubkey_substitutions length : %s", ei.pubkey_substitutions.length);
        // console.log("data_substitutions length : %s", ei.data_substitutions.length);
        
        // console.log("instruction accounts length : %s", ei.instruction.accounts.length);
        // console.log("instruction accounts length : %s", ei.instruction.accounts.length);
        
        //
        // reward: Amount
        //
        data = abi.encodePacked(LittleEndianSerializer.reverseU64(ei.reward),
        //
        // expense: Option<Amount>
        //
        ei.expense == 0 ? abi.encodePacked(hex"00") : abi.encodePacked(hex"01", LittleEndianSerializer.reverseU64(ei.expense)),
        // data,
        //
        // execute_policy: ExecutePolicy
        //
        // Enum represent uint16, so we safely convert it to uint32 for simplicity of the code
        LittleEndianSerializer.reverseU32(uint32(ei.execute_policy)),
        //
        // pubkey_substitutions: Option<Vec<(u64, PubkeySubstitution)>>
        //
        serialize(ei.pubkey_substitutions),
        //
        // data_substitutions: Option<Vec<DataSubstitution>>
        //
        serialize(ei.data_substitutions),
        //
        // instruction: Instruction
        //
         serialize(ei.instruction)
        );

        // console.log("serialize. Gas left at the end: %s", gasleft());

    }

    function serialize(bytes memory vec) internal pure returns (bytes memory data) {
        //  console.log("serialize(bytes memory vec). Gas left at the start: %s", gasleft());
        require(vec.length <= (2**64 - 1), "U64");
        
        data = abi.encodePacked(LittleEndianSerializer.reverseU64(uint64(vec.length)), vec);
        // console.log("serialize(bytes memory vec). Gas left at the end: %s", gasleft());
    }

    function serialize(DeBridgeSolana.PubkeySubstitutionTuple[] memory pss) internal pure returns (bytes memory data) {
        if (pss.length == 0) {
            data = hex"00";
        }
        else {
            // TODO: supply positive test case
            require(pss.length <= (2**64 - 1), "U64");

            data = abi.encodePacked(hex"01",
                LittleEndianSerializer.reverseU64(uint64(pss.length)),
                LittleEndianSerializer.reverseU64(pss[0].u64), pss[0].data
            );

            for (uint i = 1; i < pss.length; ++i) {
                data = abi.encodePacked(data, LittleEndianSerializer.reverseU64(pss[i].u64), pss[i].data);
            }
        }
    }

    function serialize(DeBridgeSolana.DataSubstitution[] memory dss) internal pure returns (bytes memory data) {
        if (dss.length == 0) {
            data = hex"00";
        }
        else {
            // TODO: supply positive test case
            require(dss.length <= (2**64 - 1), "U64");

            data = abi.encodePacked(hex"01",
                LittleEndianSerializer.reverseU64(uint64(dss.length)),
                dss[0].data
            );

            for (uint i = 1; i < dss.length; ++i) {
                data = abi.encodePacked(data, dss[i].data);
            }
        }
    }

    function serialize(DeBridgeSolana.Instruction memory i) internal pure returns (bytes memory data) {
        data = abi.encodePacked(
            i.program_id,
            serialize(i.accounts),
            serialize(i.data)
        );
    }

    function serialize(DeBridgeSolana.AccountMeta memory am) internal pure returns (bytes memory data) {
        data = abi.encodePacked(
            am.pubkey,
            am.is_signer,
            am.is_writable
        );
    }

    function serialize(DeBridgeSolana.AccountMeta[] memory ams) internal pure returns (bytes memory data) {
        // console.log("serialize(DeBridgeSolana.AccountMeta[]. Gas left at the start: %s", gasleft());
        // console.log("ams.length: %s", ams.length);
        require(ams.length <= (2**64 - 1), "U64");

        data = abi.encodePacked(LittleEndianSerializer.reverseU64(uint64(ams.length)));
        // console.log("before  for (uint i = 0; i < ams.length; ++i) {. Gas left at the start: %s", gasleft());
        for (uint i = 0; i < ams.length; ++i) {
            data = abi.encodePacked(data,
            //  serialize(ams[i]) 
            ams[i].pubkey,
            ams[i].is_signer,
            ams[i].is_writable
            );
        }

        // console.log("serialize(DeBridgeSolana.AccountMeta[]. Gas left at the end: %s", gasleft());
    }
}


library LittleEndianSerializer {

    function reverseU64(uint64 input) internal pure returns (uint64 v) {
        assembly {
            let temp := 0
            for { let i := 0 } lt(i, 8) { i := add(i, 1) } {
                temp := or(shl(8, temp), and(shr(mul(i, 8), input), 0xFF))
            }
            v := temp
        }
    }


    function reverseU32(uint32 input) internal pure returns (uint32 v) {
        assembly {
            let temp := 0
            for { let i := 0 } lt(i, 4) { i := add(i, 1) } {
                temp := or(shl(8, temp), and(shr(mul(i, 8), input), 0xFF))
            }
            v := temp
        }
    }

    // function reverseU64(uint64 input) internal pure returns (uint64 v) {
    //     // return 1;
    //     v = input;

    //     // swap bytes
    //     v = ((v & 0xFF00FF00FF00FF00) >> 8) | ((v & 0x00FF00FF00FF00FF) << 8);

    //     // swap 2-byte long pairs
    //     v = ((v & 0xFFFF0000FFFF0000) >> 16) | ((v & 0x0000FFFF0000FFFF) << 16);

    //     // swap 4-byte long pairs
    //     v = (v >> 32) | (v << 32);
    // }

    // function reverseU32(uint32 input) internal pure returns (uint32 v) {
    //     v = input;

    //     // swap bytes
    //     v = ((v & 0xFF00FF00) >> 8) | ((v & 0x00FF00FF) << 8);

    //     // swap 2-byte long pairs
    //     v = (v >> 16) | (v << 16);
    // }
}