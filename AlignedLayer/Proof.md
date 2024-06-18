# Sending and Verifying SP1 Proofs with Aligned

![image](https://github.com/blackowltr/Testnetler-ve-Rehberler/assets/107190154/9a13eba8-6eb1-4ad4-b3a5-1feecbd8b4b4)

## Step 1: Download and Install Aligned

To send proofs in the testnet, download and install Aligned by running the following command:

```bash
curl -L https://raw.githubusercontent.com/yetanotherco/aligned_layer/main/batcher/aligned/install_aligned.sh | bash
```

If you experience any issues, upgrade by running the same command.

## Step 2: Download Example SP1 Proof Files

Download an example SP1 proof file along with its ELF file using the command below:

```bash
curl -L https://raw.githubusercontent.com/yetanotherco/aligned_layer/main/batcher/aligned/get_proof_test_files.sh | bash
```

## Step 3: Send the Proof

Send the proof with the following command:

```bash
aligned submit \
  --proving_system SP1 \
  --proof ~/.aligned/test_files/sp1_fibonacci.proof \
  --vm_program ~/.aligned/test_files/sp1_fibonacci-elf \
  --aligned_verification_data_path ~/aligned_verification_data \
  --conn wss://batcher.alignedlayer.com
```

Wait a few seconds for your proof to be verified in Aligned.

## Step 4: Verify the Proof On-Chain

Check that your proof has been verified with the following command:

```bash
aligned verify-proof-onchain \
  --aligned-verification-data ~/aligned_verification_data/*.json \
  --rpc https://ethereum-holesky-rpc.publicnode.com \
  --chain holesky
```

That's it! You've successfully sent and verified your SP1 proofs using Aligned.
