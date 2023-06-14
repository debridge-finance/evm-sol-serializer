// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

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
        data = bytes.concat(
            bytes1(0), bytes1(0), bytes1(0), bytes1(0),
            submissionAuthWalletAmount.account_index.uint64ToLittleEndian(),
            submissionAuthWalletAmount.offset.uint64ToLittleEndian(),
            submissionAuthWalletAmount.is_big_endian == true ? bytes1(uint8(1)) : bytes1(0),
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
        Seed[] seeds;
        uint8 bump;
    }

    struct Seed {
        bytes data;
    }

    function serialize(SubmissionAuthWallet memory submissionAuthWallet) internal pure returns (bytes memory data) {
        data = bytes.concat(
            bytes1(0), bytes1(0), bytes1(0), bytes1(0),
            submissionAuthWallet.token_mint);
    }

    function serialize(BySeeds memory bySeeds) internal pure returns (bytes memory data) {
        data = bytes.concat(
            bytes1(uint8(1)), bytes1(0), bytes1(0), bytes1(0),
            bySeeds.program_id,
            serialize(bySeeds.seeds)
        );

        if (bySeeds.bump == 0) {
            data = bytes.concat(data, bytes1(0));
        }
        else {
            data = bytes.concat(data, bytes1(uint8(1)), bytes1(bySeeds.bump));
        }
    }

    function serialize(Seed[] memory seeds) internal pure returns (bytes memory data) {
        require(seeds.length <= (2**64 - 1), "U64");

        data = uint64(seeds.length).uint64ToLittleEndian();
        for (uint i = 0; i < seeds.length; i++) {
            data = bytes.concat(data, seeds[i].data);
        }
    }

    function getArbitrarySeed(bytes memory vec) internal pure returns (DeBridgeSolanaPubkeySubstitutions.Seed memory) {
        bytes memory data = bytes.concat(bytes1(0), bytes1(0), bytes1(0), bytes1(0));
        data = bytes.concat(data, uint64(vec.length).uint64ToLittleEndian(), vec);
        return DeBridgeSolanaPubkeySubstitutions.Seed({
            data: data
        });
    }

    function getSubmissionAuthSeed() internal pure returns (DeBridgeSolanaPubkeySubstitutions.Seed memory) {
        bytes memory data = bytes.concat(bytes1(uint8(1)), bytes1(0), bytes1(0), bytes1(0));

        return DeBridgeSolanaPubkeySubstitutions.Seed({
            data: data
        });
    }
}

library DeBridgeSolanaSerializer {
    using LittleEndianSerializer for uint64;
    using LittleEndianSerializer for uint32;

    function serialize(DeBridgeSolana.ExternalInstruction memory ei) internal pure returns (bytes memory data) {
        //
        // reward: Amount
        //
        data = ei.reward.uint64ToLittleEndian();

        //
        // expense: Option<Amount>
        //
        if (ei.expense == 0) {
            data = bytes.concat(data, bytes1(0));
        }
        else {
            data = bytes.concat(data, bytes1(uint8(1)), ei.expense.uint64ToLittleEndian());
        }

        //
        // execute_policy: ExecutePolicy
        //
        // Enum represent uint16, so we safely convert it to uint32 for simplicity of the code
        data = bytes.concat(data, uint32(ei.execute_policy).uint32ToLittleEndian());

        //
        // pubkey_substitutions: Option<Vec<(u64, PubkeySubstitution)>>
        //
        data = bytes.concat(data, serialize(ei.pubkey_substitutions));

        //
        // data_substitutions: Option<Vec<DataSubstitution>>
        //
        data = bytes.concat(data, serialize(ei.data_substitutions));

        //
        // instruction: Instruction
        //
        data = bytes.concat(data, serialize(ei.instruction));
    }

    function serialize(bytes memory vec) internal pure returns (bytes memory data) {
        require(vec.length <= (2**64 - 1), "U64");

        data = bytes.concat(data, uint64(vec.length).uint64ToLittleEndian(), vec);
    }

    function serialize(DeBridgeSolana.PubkeySubstitutionTuple[] memory pss) internal pure returns (bytes memory data) {
        if (pss.length == 0) {
            data = bytes.concat(data, bytes1(0));
        }
        else {
            // TODO: supply positive test case
            require(pss.length <= (2**64 - 1), "U64");

            data = bytes.concat(
                data,
                bytes1(uint8(1)),
                uint64(pss.length).uint64ToLittleEndian()
            );

            for (uint i = 0; i < pss.length; i++) {
                data = bytes.concat(data, pss[i].u64.uint64ToLittleEndian(), pss[i].data);
            }
        }
    }

    function serialize(DeBridgeSolana.DataSubstitution[] memory dss) internal pure returns (bytes memory data) {
        if (dss.length == 0) {
            data = bytes.concat(data, bytes1(0));
        }
        else {
            // TODO: supply positive test case
            require(dss.length <= (2**64 - 1), "U64");

            data = bytes.concat(
                data,
                bytes1(uint8(1)),
                uint64(dss.length).uint64ToLittleEndian()
            );

            for (uint i = 0; i < dss.length; i++) {
                data = bytes.concat(data, dss[i].data);
            }
        }
    }

    function serialize(DeBridgeSolana.Instruction memory i) internal pure returns (bytes memory data) {
        data = bytes.concat(
            data,
            i.program_id,
            serialize(i.accounts),
            serialize(i.data)
        );
    }

    function serialize(DeBridgeSolana.AccountMeta memory am) internal pure returns (bytes memory data) {
        data = bytes.concat(
            am.pubkey,
            bytes1(uint8(am.is_signer ? 1 : 0)),
            bytes1(uint8(am.is_writable ? 1 : 0))
        );
    }

    function serialize(DeBridgeSolana.AccountMeta[] memory ams) internal pure returns (bytes memory data) {
        require(ams.length <= (2**64 - 1), "U64");

        data = uint64(ams.length).uint64ToLittleEndian();
        for (uint i = 0; i < ams.length; i++) {
            data = bytes.concat(data, serialize(ams[i]));
        }
    }
}


library LittleEndianSerializer {

    function uint64ToLittleEndian(uint64 v) internal pure returns (bytes memory r) {
        return _uint64ToLittleEndian(v);
    }

    function uint32ToLittleEndian(uint32 v) internal pure returns (bytes memory r) {
        return _uint32ToLittleEndian(v);
    }

    function _uint64ToLittleEndian(uint64 x) internal pure returns (bytes memory) {
        uint64 temp;
        assembly {
            for { let i := 0 } lt(i, 8) { i := add(i, 1) } {
                temp := or(shl(8, temp), and(shr(mul(i, 8), x), 0xFF))
            }
        }
        return abi.encodePacked(temp);
    }

    function _uint32ToLittleEndian(uint32 x) internal pure returns (bytes memory) {
        uint32 temp;
        assembly {
            for { let i := 0 } lt(i, 4) { i := add(i, 1) } {
                temp := or(shl(8, temp), and(shr(mul(i, 8), x), 0xFF))
            }
        }
        return abi.encodePacked(temp);
    }
}