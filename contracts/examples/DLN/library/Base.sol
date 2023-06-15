// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

library DlnBase {
  bytes32 private constant src5qyZHqTqecJV4aY6Cb6zDZLMDzrDKKezs22MPHr4 =
    0x0d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded;
  bytes32 private constant ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL =
    0x8C97258F4E2489F1BB3D1029148E0D830B5A1399DAFF1084048E7BD8DBE9F859;

  // dln_src::ID
  bytes32 internal constant dln_src_ID = src5qyZHqTqecJV4aY6Cb6zDZLMDzrDKKezs22MPHr4;

  // spl_associated_token_account::ID
  bytes32 internal constant spl_associated_token_account_ID =
    ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL;
}
