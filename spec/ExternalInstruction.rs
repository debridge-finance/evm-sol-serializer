
pub struct ExternalInstruction {
    /// Reward for execute this ix in Solana
    pub reward: Amount,
    /// How much Solana this ix need to process
    ///
    /// If you create a PDA, you will need to specify its rent here
    pub expense: Option<Amount>,
    /// Policy for specify execution
    pub execute_policy: ExecutePolicy,
    /// Substitutions for pubkeys in instruction
    ///
    /// Because submission id (and, as a consequence, any PDAs from it)
    /// is not predictable, we can form any replacements for the public
    /// key instruction.
    pub pubkey_substitutions: Option<Vec<(u64, PubkeySubstitution)>>,
    /// Substitutions for data in instruction
    ///
    /// Since some data may not be known at the
    /// time of formation, we provide a spoofing
    /// mechanism.
    pub data_substitutions: Option<Vec<DataSubstitution>>,
    /// Solana instructions for execution
    pub instruction: Instruction,
}

enum ExecutePolicy {
    /// No execution modifiers
    Empty,
    /// The next instruction should be executed in the same transaction
    MandatoryBlock,
}

pub enum SeedVariants {
    Arbitrary(Vec<u8>),
    SubmissionAuth,
}

pub enum PubkeySubstitution {
    /// Replacing an account with an associated wallet
    SubmissionAuthWallet {
        token_mint: Pubkey,
    },
    /// Replacing an account with a PDA account with the following seeds
    BySeeds {
        program_id: Pubkey,
        seeds: Vec<SeedVariants>,
        /// If bump is specified, it will be used,
        /// if it is not specified, it will be calculated
        /// dynamically (and use resources in tx)
        bump: Option<u8>,
    },
}

pub struct AccountMeta {
    /// The pubkey of the account
    pub pubkey: Pubkey,
    pub is_writable: bool,
    pub is_signer: bool,
}

pub struct AccountMeta {
    pub pubkey: Pubkey,
    pub is_signer: bool,
    pub is_writable: bool,
}

struct Instruction {
    pub program_id: Pubkey,
    pub accounts: Vec<AccountMeta>,
    pub data: Vec<u8>,
}