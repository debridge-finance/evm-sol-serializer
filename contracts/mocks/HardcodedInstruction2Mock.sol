// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../library/DeBridgeSolana.sol";

contract HardcodedInstruction2Mock {
    using DeBridgeSolanaSerializer for DeBridgeSolana.ExternalInstruction;

    // src5qyZHqTqecJV4aY6Cb6zDZLMDzrDKKezs22MPHr4
    bytes32 constant programId = 0x0d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded;

    // ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL
    bytes32 constant programId_2 = 0x8C97258F4E2489F1BB3D1029148E0D830B5A1399DAFF1084048E7BD8DBE9F859;

    function serializeNativeExternalInstruction2() external pure returns (bytes memory) {
        DeBridgeSolana.ExternalInstruction memory externalInstruction = DeBridgeSolana.ExternalInstruction({
            reward: 0,
            expense: 0,
            execute_policy: DeBridgeSolana.ExecutePolicy.Empty,
            pubkey_substitutions: getPubkeySubstitutionTuples(),
            data_substitutions: getDataSubstitutions(),
            instruction: DeBridgeSolana.Instruction({
                // [50; 32]
                program_id: programId,
                accounts: getAccountMetas(),
                data: getInstructionData()
            })
        });

        return externalInstruction.serialize();
    }

    function getInstructionData() internal pure returns (bytes memory) {
        // [89,81,180,79,142,144,66,251,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,254]
        return abi.encodePacked(
                    bytes1(uint8(89)),
                    bytes1(uint8(81)),
                    bytes1(uint8(180)),
                    bytes1(uint8(79)),
                    bytes1(uint8(142)),
                    bytes1(uint8(144)),
                    bytes1(uint8(66)),
                    bytes1(uint8(251)),
                    bytes32(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe)
                );
    }

    function getPubkeySubstitutionTuples() internal pure returns (DeBridgeSolana.PubkeySubstitutionTuple[] memory pss) {
        pss = new DeBridgeSolana.PubkeySubstitutionTuple[](7);
        pss[0] = getPubkeySubstitutionTuple_0();
        pss[1] = getPubkeySubstitutionTuple_1();
        pss[2] = getPubkeySubstitutionTuple_2();
        pss[3] = getPubkeySubstitutionTuple_3();
        pss[4] = getPubkeySubstitutionTuple_4();
        pss[5] = getPubkeySubstitutionTuple_5();
        pss[6] = getPubkeySubstitutionTuple_6();
    }

    function getPubkeySubstitutionTuple_0() internal pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
        bytes[] memory seeds = new bytes[](1);
        // [83,84,65,84,69]
        seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(
            bytes1(uint8(83)),
            bytes1(uint8(84)),
            bytes1(uint8(65)),
            bytes1(uint8(84)),
            bytes1(uint8(69))
        ));

        return DeBridgeSolana.PubkeySubstitutionTuple({
                u64: 2,
                data: DeBridgeSolanaPubkeySubstitutions.serialize(DeBridgeSolanaPubkeySubstitutions.BySeeds({
                    program_id: programId,
                    seeds: seeds,
                    bump: 0
                }))
            });
    }

    function getPubkeySubstitutionTuple_1() internal pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
        bytes[] memory seeds = new bytes[](1);
        // [70,69,69,32,76,69,68,71,69,82]
        seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(
            bytes1(uint8(70)),
            bytes1(uint8(69)),
            bytes1(uint8(69)),
            bytes1(uint8(32)),
            bytes1(uint8(76)),
            bytes1(uint8(69)),
            bytes1(uint8(68)),
            bytes1(uint8(71)),
            bytes1(uint8(69)),
            bytes1(uint8(82))
        ));

        return DeBridgeSolana.PubkeySubstitutionTuple({
                u64: 3,
                data: DeBridgeSolanaPubkeySubstitutions.serialize(DeBridgeSolanaPubkeySubstitutions.BySeeds({
                    program_id: programId,
                    seeds: seeds,
                    bump: 0
                }))
            });
    }

    function getPubkeySubstitutionTuple_2() internal pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
        bytes[] memory seeds = new bytes[](2);

        // [70,69,69,95,76,69,68,71,69,82,95,87,65,76,76,69,84]
        bytes memory m = abi.encodePacked(
            bytes1(uint8(70)),
            bytes1(uint8(69)),
            bytes1(uint8(69)),
            bytes1(uint8(95))
        );

        m = abi.encodePacked(
            m,
            bytes1(uint8(76)),
            bytes1(uint8(69)),
            bytes1(uint8(68)),
            bytes1(uint8(71))
        );

        m = abi.encodePacked(
            m,
            bytes1(uint8(69)),
            bytes1(uint8(82)),
            bytes1(uint8(95)),
            bytes1(uint8(87)),
            bytes1(uint8(65)),
            bytes1(uint8(76)),
            bytes1(uint8(76)),
            bytes1(uint8(69)),
            bytes1(uint8(84))
        );
        seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(m);

        // [100; 32]
        seeds[1] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(bytes32(0x6464646464646464646464646464646464646464646464646464646464646464)));

        return DeBridgeSolana.PubkeySubstitutionTuple({
                u64: 4,
                data: DeBridgeSolanaPubkeySubstitutions.serialize(DeBridgeSolanaPubkeySubstitutions.BySeeds({
                    program_id: programId,
                    seeds: seeds,
                    bump: 0
                }))
            });
    }

    function getPubkeySubstitutionTuple_3() internal pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
        bytes[] memory seeds = new bytes[](2);

        // [71,73,86,69,95,79,82,68,69,82,95,83,84,65,84,69]
        bytes memory m = abi.encodePacked(
            bytes1(uint8(71)),
            bytes1(uint8(73)),
            bytes1(uint8(86)),
            bytes1(uint8(69))
        );

        m = abi.encodePacked(m,
            bytes1(uint8(95)),
            bytes1(uint8(79)),
            bytes1(uint8(82)),
            bytes1(uint8(68))
        );

        seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(
            m,
            bytes1(uint8(69)),
            bytes1(uint8(82)),
            bytes1(uint8(95)),
            bytes1(uint8(83)),
            bytes1(uint8(84)),
            bytes1(uint8(65)),
            bytes1(uint8(84)),
            bytes1(uint8(69))
        ));

        // [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,254]
        seeds[1] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(bytes32(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe)));

        return DeBridgeSolana.PubkeySubstitutionTuple({
                u64: 6,
                data: DeBridgeSolanaPubkeySubstitutions.serialize(DeBridgeSolanaPubkeySubstitutions.BySeeds({
                    program_id: programId,
                    seeds: seeds,
                    bump: 0
                }))
            });
    }

    function getPubkeySubstitutionTuple_4() internal pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
        bytes[] memory seeds = new bytes[](3);

        // [200; 32]
        seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(bytes32(0xc8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8)));

        // [6,221,246,225,215,101,161,147,217,203,225,70,206,235,121,172,28,180,133,237,95,91,55,145,58,140,245,133,126,255,0,169]
        bytes memory m = abi.encodePacked(
            bytes1(uint8(6)),
            bytes1(uint8(221)),
            bytes1(uint8(246)),
            bytes1(uint8(225))
        );

        m = abi.encodePacked(
            m,
            bytes1(uint8(215)),
            bytes1(uint8(101)),
            bytes1(uint8(161)),
            bytes1(uint8(147))
        );

        m = abi.encodePacked(
            m,
            bytes1(uint8(217)),
            bytes1(uint8(203)),
            bytes1(uint8(225)),
            bytes1(uint8(70))
        );

        m = abi.encodePacked(
            m,
            bytes1(uint8(206)),
            bytes1(uint8(235)),
            bytes1(uint8(121)),
            bytes1(uint8(172))
        );

        m = abi.encodePacked(
            m,
            bytes1(uint8(28)),
            bytes1(uint8(180)),
            bytes1(uint8(133)),
            bytes1(uint8(237))
        );

        seeds[1] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(
            m,
            bytes1(uint8(95)),
            bytes1(uint8(91)),
            bytes1(uint8(55)),
            bytes1(uint8(145)),
            bytes1(uint8(58)),
            bytes1(uint8(140)),
            bytes1(uint8(245)),
            bytes1(uint8(133)),
            bytes1(uint8(126)),
            bytes1(uint8(255)),
            bytes1(uint8(0)),
            bytes1(uint8(169))
        ));

        // [100; 32]
        seeds[2] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(bytes32(0x6464646464646464646464646464646464646464646464646464646464646464)));

        return DeBridgeSolana.PubkeySubstitutionTuple({
                u64: 7,
                data: DeBridgeSolanaPubkeySubstitutions.serialize(DeBridgeSolanaPubkeySubstitutions.BySeeds({
                    program_id: programId_2,
                    seeds: seeds,
                    bump: 0
                }))
            });
    }

    function getPubkeySubstitutionTuple_5() internal pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
        bytes[] memory seeds = new bytes[](2);

        // [71,73,86,69,95,79,82,68,69,82,95,87,65,76,76,69,84,]
        bytes memory m = abi.encodePacked(
            bytes1(uint8(71)),
            bytes1(uint8(73)),
            bytes1(uint8(86)),
            bytes1(uint8(69))
        );

        m = abi.encodePacked(
            m,
            bytes1(uint8(95)),
            bytes1(uint8(79)),
            bytes1(uint8(82)),
            bytes1(uint8(68))
        );

        seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(
            m,
            bytes1(uint8(69)),
            bytes1(uint8(82)),
            bytes1(uint8(95)),
            bytes1(uint8(87)),
            bytes1(uint8(65)),
            bytes1(uint8(76)),
            bytes1(uint8(76)),
            bytes1(uint8(69)),
            bytes1(uint8(84))
        ));

        // [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,254]
        seeds[1] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(bytes32(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe)));

        return DeBridgeSolana.PubkeySubstitutionTuple({
                u64: 9,
                data: DeBridgeSolanaPubkeySubstitutions.serialize(DeBridgeSolanaPubkeySubstitutions.BySeeds({
                    program_id: programId,
                    seeds: seeds,
                    bump: 0
                }))
            });
    }

    function getPubkeySubstitutionTuple_6() internal pure returns (DeBridgeSolana.PubkeySubstitutionTuple memory) {
        bytes[] memory seeds = new bytes[](2);

        // [65,85,84,72,79,82,73,90,69,68,95,78,65,84,73,86,69,95,83,69,78,68,69,82]
        bytes memory m = abi.encodePacked(
            bytes1(uint8(65)),
            bytes1(uint8(85)),
            bytes1(uint8(84)),
            bytes1(uint8(72))
        );

        m = abi.encodePacked(
            m,
            bytes1(uint8(79)),
            bytes1(uint8(82)),
            bytes1(uint8(73)),
            bytes1(uint8(90))
        );


        m = abi.encodePacked(
            m,
            bytes1(uint8(69)),
            bytes1(uint8(68)),
            bytes1(uint8(95)),
            bytes1(uint8(78))
        );

        m = abi.encodePacked(
            m,
            bytes1(uint8(65)),
            bytes1(uint8(84)),
            bytes1(uint8(73)),
            bytes1(uint8(86))
        );

        seeds[0] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(
            m,
            bytes1(uint8(69)),
            bytes1(uint8(95)),
            bytes1(uint8(83)),
            bytes1(uint8(69)),
            bytes1(uint8(78)),
            bytes1(uint8(68)),
            bytes1(uint8(69)),
            bytes1(uint8(82))
        ));

        // [10; 32]
        seeds[1] = DeBridgeSolanaPubkeySubstitutions.getArbitrarySeed(abi.encodePacked(bytes32(0x0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A)));

        return DeBridgeSolana.PubkeySubstitutionTuple({
                u64: 11,
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
            // 8WCEensgLisgqYgW9b8f5Av2KZQcWs3K8Xc7LyTSGFos
            pubkey: 0x6f7c5b17390ae4be9495d943c750d6c0eb63268e1b4680267c2b4f6c718eed3e,
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
            // 4fSpYowMTPzuojArBWgsNAd6tPPSiWxAoXWG9VRTodth
            pubkey: 0x366c537907e93ad66070ac62454ff7d9ddf86653266f23260c2a3db8f05c4e96,
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
