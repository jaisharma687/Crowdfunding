# MyToken Contract

## Overview

The `MyToken` contract is a Solidity smart contract that implements a token (ERC20 standard) with additional functionalities for managing crowdfunding campaigns. It allows users to create campaigns, contribute funds to campaigns, cancel contributions, withdraw funds from successful campaigns, and request refunds from unsuccessful campaigns.

## Features

### ERC20 Token

The contract inherits from the `ERC20` contract provided by the OpenZeppelin library, which implements the ERC20 standard functionalities like `transfer`, `approve`, and `transferFrom`.

### Crowdfunding Campaigns

- **Create Campaign**: Users can create new crowdfunding campaigns by specifying the goal amount and the duration of the campaign.

- **Contribute**: Contributors can send funds to a specific campaign by providing the campaign ID and the amount to contribute.

- **Cancel Contribution**: Contributors can cancel their contributions before the campaign deadline.

- **Withdraw Funds**: Campaign owners can withdraw collected funds after the campaign deadline if the goal is met.

- **Refund**: Contributors can request a refund if the campaign deadline passes without meeting the goal.

## Contract Structure

- **State Variables**:
    - `priceInUSD`: Immutable variable representing the price of the token in USD.
    - `campaignId`: Mapping to store campaign details.
    - `numberOfCampaigns`: Counter to track the number of campaigns created.
    - `tokenAddress`: Address of the token contract.

- **Constructor**:
    - Initializes the contract with the token name, symbol, price in USD, and token address.

- **Functions**:
    - `mint`: Allows the owner to mint new tokens.
    - `getTokenPriceInUSD`: Retrieves the price of the token in USD.
    - `createCampaign`: Creates a new crowdfunding campaign.
    - `contribute`: Allows users to contribute funds to a campaign.
    - `cancelContribution`: Allows contributors to cancel their contributions.
    - `withdrawFunds`: Allows campaign owners to withdraw funds after the campaign deadline.
    - `refund`: Allows contributors to request refunds from unsuccessful campaigns.

## Usage

1. Deploy the `MyToken` contract with the necessary parameters (name, symbol, price in USD, token address).
2. Mint tokens using the `mint` function if required.
3. Users can create crowdfunding campaigns using the `createCampaign` function.
4. Contributors can contribute funds to campaigns using the `contribute` function.
5. Campaign owners can withdraw funds using the `withdrawFunds` function if the campaign is successful.
6. Contributors can request refunds using the `refund` function if the campaign is unsuccessful.

## License

This contract is licensed under the MIT License. See the `LICENSE` file for details.

## Disclaimer

This contract is provided as-is without any warranty. Use it at your own risk.
