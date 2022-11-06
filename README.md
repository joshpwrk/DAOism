# WorkAgreement

## WorkAgreement.sol: 
- allows creation / cancelation of employment contracts 
- the salary information is hashed from sha256(secret, salary) off-chain before posted on-chain
- a `submitAverageSalaryProof()` routes to the `ZKAverage` and `ZKHash` on-chain verifiers which verify that an certain role does in fact match the claimed average

## ZK Verifiers (ZKAverage.sol, ZKHash.sol)
- Generated via Circom 2.1.1 and snarkjs. 

Flow:
1. Employer generates a ZKAverage witness off-chain via dApp using (a) unhashed salaries (b) claimed averages per role
2. Employer generates aa ZKHash witness off-chain via dApp using (a) unhashed salaries (b) hashed salaries (c) secret 
3. The public inputs (unhashed salaries, claimed averages) + proofs are submitted to `WorkAgreement.submitAverageSalaryProof()`
4. Within the function, `WorkAgremeent.sol` first routes to `ZKAverage.sol` to verify the average calculation
5. Then, `WorkAgreement.sol` takes in all the hashed salaries from the contract state and routes those to `ZKHash.sol` to ensure that the supplied salaries match the ones on-chain

## The Why:
With on-chain ZK-SNARK verifiers, it's possible to make provable claims about employee salaries without revealing their salaries to the public. This has a couple very interesting usecases:
(1) Negotiations and competitiveness: share the average salary per contributor role without sharing peer salaries
(2) Equity: share salary ranges based on demographics and roles, thus proving equal pay without revealing sensitive details
(3) Undercollateralized loans: submit salary proofs to decentralized lending protocols like Aave to get more attractive loans due to better credit worthiness
(4) Sybil resistance: use these contracts to prove humanity

## Testing
`forge test` 

## Deployment and Seeding
deploy WorkAgreement.sol: `source.env; forge script Deploy --rpc-url $OP_GOERLI_RPC_URL --broadcast --verify`
seed WorkAgreement.sol: `forge script Seed --rpc-url $OP_GOERLI_RPC_URL --broadcast`
deploy ZK verifiers: `forge DeployZKVerifier --rpc-url $OP_GOERLI_RPC_URL --broadcast --verify`
submit proof: `forge Prove --rpc-url $OP_GOERLI_RPC_URL --broadcast`

Limitations
1. Ideally, the ZKHash and ZKAverage circuits would live in a single circuit, thus ensuring that the salaries of current employees (no more and no less) were used in the average calculation. Unfortunately, due to the gigantic size of the circuit, it was infeasible to generate a single proof during the timespan of the hackathon (single laptop)
2. Circomlib's SHA256 has very sparse documentation and we had significant issues making solidity's sha256() match the inputs and outputs of Circoms template
