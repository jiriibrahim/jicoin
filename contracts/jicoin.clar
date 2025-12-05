;; jicoin - a simple fungible token implemented in Clarity

;; This contract defines a fungible token named "Jicoin" and exposes
;; a small API for minting (owner only), transferring, and querying
;; balances and total supply.

;; ------------------------------------------------------------
;; Token definition
;; ------------------------------------------------------------

(define-fungible-token jicoin)

;; ------------------------------------------------------------
;; Constants & errors
;; ------------------------------------------------------------

(define-constant TOKEN-NAME "Jicoin")
(define-constant TOKEN-SYMBOL "JIC")
(define-constant TOKEN-DECIMALS u6)

(define-constant ERR-NOT-OWNER (err u100))
(define-constant ERR-INSUFFICIENT-BALANCE (err u101))
(define-constant ERR-NON-POSITIVE-AMOUNT (err u102))

;; ------------------------------------------------------------
;; Contract state
;; ------------------------------------------------------------

;; The account that deployed this contract. Only the owner may mint.
(define-data-var contract-owner principal tx-sender)

;; Cached total supply of jicoin.
(define-data-var total-supply uint u0)

;; ------------------------------------------------------------
;; Public functions
;; ------------------------------------------------------------

;; Mint new tokens to a recipient. Only the contract owner may call this.
(define-public (mint (recipient principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-OWNER)
    (asserts! (> amount u0) ERR-NON-POSITIVE-AMOUNT)
    (try! (ft-mint? jicoin amount recipient))
    (var-set total-supply (+ (var-get total-supply) amount))
    (ok amount)))

;; Transfer tokens from the caller (tx-sender) to a recipient.
(define-public (transfer (recipient principal) (amount uint))
  (begin
    (asserts! (> amount u0) ERR-NON-POSITIVE-AMOUNT)
    (asserts! (>= (ft-get-balance jicoin tx-sender) amount) ERR-INSUFFICIENT-BALANCE)
    (try! (ft-transfer? jicoin amount tx-sender recipient))
    (ok true)))

;; ------------------------------------------------------------
;; Read-only functions
;; ------------------------------------------------------------

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance jicoin who)))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

(define-read-only (get-owner)
  (ok (var-get contract-owner)))

(define-read-only (get-name)
  (ok TOKEN-NAME))

(define-read-only (get-symbol)
  (ok TOKEN-SYMBOL))

(define-read-only (get-decimals)
  (ok TOKEN-DECIMALS))
