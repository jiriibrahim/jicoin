# jicoin

A simple fungible token smart contract for the Stacks blockchain, built with
[Clarinet](https://github.com/hirosystems/clarinet).

`jicoin` is an example project that demonstrates how to:

- Scaffold a Clarinet project
- Implement a fungible token in Clarity
- Run static analysis and checks with `clarinet check`

## Project structure

- `Clarinet.toml` – Clarinet project configuration
- `contracts/jicoin.clar` – Clarity smart contract implementing the Jicoin token
- `settings/` – Network configuration files (Devnet, Testnet, Mainnet)
- `tests/` – Placeholder for TypeScript unit tests
- `package.json`, `tsconfig.json`, `vitest.config.ts` – Testing/tooling configuration

## Requirements

- [Clarinet](https://docs.hiro.so/clarinet) (already installed on this system)
- Node.js (for running tests, if you add them later)

You can verify Clarinet is available with:

```bash path=null start=null
clarinet --version
```

## Usage

From the project root (`/home/anthony/Documents/GitHub/jicoin`):

### Check the contract

Run Clarinet's static analysis and type checks:

```bash path=null start=null
clarinet check
```

### REPL

Launch a local REPL to interact with the contract:

```bash path=null start=null
clarinet repl
```

Inside the REPL, you can call read-only functions, for example:

```clojure path=null start=null
(contract-call? .jicoin get-name)
(contract-call? .jicoin get-symbol)
(contract-call? .jicoin get-decimals)
```

### Minting and transferring Jicoin

By default, the contract owner is the account that deployed the contract. Only the
owner can mint new tokens using the `mint` function.

Example (from REPL, replacing `<recipient>` with a principal):

```clojure path=null start=null
;; Mint 1_000 Jicoin to a recipient
(contract-call? .jicoin mint '<recipient> u1000)

;; Transfer 100 Jicoin from the caller to another principal
(contract-call? .jicoin transfer '<other-principal> u100)
```

You can query balances and total supply with:

```clojure path=null start=null
(contract-call? .jicoin get-balance '<principal>)
(contract-call? .jicoin get-total-supply)
```

## Development notes

- The `jicoin` token is defined via `define-fungible-token` and uses the
  standard `ft-mint?`, `ft-transfer?`, and `ft-get-balance` helpers.
- Errors are returned as response codes:
  - `u100` – caller is not the contract owner
  - `u101` – insufficient balance for transfer
  - `u102` – non-positive amount passed to `mint` or `transfer`

Feel free to extend this project with more advanced features such as
SIP-010 compliance, allowances, or on-chain metadata.
