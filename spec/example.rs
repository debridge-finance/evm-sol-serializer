// init_wallet_if_needed.rs

let action_beneficiary = Pubkey::new_from_array([200; 32]);
let order_give_token_address = Pubkey::new_from_array([100; 32]);
let reward = 1000;

let ix = debridge::ExternalInstruction {
    // Input param
    reward,
    // Constant
    expense: Some(2039280),
    instruction: Instruction {
        // Constant
        // 0x8c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859
        program_id: Pubkey::from_str("ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL").unwrap(),
        accounts: vec![
            // Pubkey Auth Placeholder, constant
            AccountMeta {
                // 0x1968562fef0aab1b1d8f99d44306595cd4ba41d7cc899c007a774d23ad702ff6
                pubkey: Pubkey::from_str("2iBUASRfDHgEkuZ91Lvos5NxwnmiryHrNbWBfEVqHRQZ")
                    .unwrap(),
                is_signer: true,
                is_writable: true,
            },
            // Can be any - not important, will be replaced by substituion  later
            AccountMeta {
                // 0x9f3d96f657370bf1dbb3313efba51ea7a08296ac33d77b949e1b62d538db37f2
                pubkey: Pubkey::from_str("BicJ4dmuWD3bfBrJyKKeqzczWDSGUepUpaKWmC6XRoJZ")
                    .unwrap(),
                is_signer: false,
                is_writable: true,
            },
            // Input Param
            AccountMeta {
                pubkey: action_beneficiary.clone(),
                is_signer: false,
                is_writable: false,
            },
            // Input Param
            AccountMeta {
                pubkey: order_give_token_address,
                is_signer: false,
                is_writable: false,
            },
            // Constant
            AccountMeta {
                //0x0000000000000000000000000000000000000000000000000000000000000000
                pubkey: Pubkey::from_str("11111111111111111111111111111111").unwrap(),
                is_signer: false,
                is_writable: false,
            },
            // Constant (at this stage, will be able to take two values later)
            AccountMeta {
                // 0x06ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a9
                pubkey: Pubkey::from_str("TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA")
                    .unwrap(),
                is_signer: false,
                is_writable: false,
            },
        ],
        // Constant
        data: vec![1],
    }
    .into(),
    pubkey_substitutions: Some(vec![(
        // Constant
        1,
        PubkeySubstitution::BySeeds {
            // 0x8c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859
            program_id: Pubkey::from_str("ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL")
                .unwrap(),
            seeds: vec![
                // Input Param
                SeedVariants::Arbitrary(action_beneficiary.to_bytes().to_vec()),
                // Constant
                SeedVariants::Arbitrary(
                    // 0x06ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a9
                    Pubkey::from_str("TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA")
                        .unwrap()
                        .to_bytes()
                        .to_vec(),
                ),
                // Input Param
                SeedVariants::Arbitrary(order_give_token_address.to_bytes().to_vec()),
            ],
            bump: None,
        },
    )]),
    // Constant
    execute_policy: ExecutePolicy::Empty,
    // Constant
    data_substitutions: None,
};