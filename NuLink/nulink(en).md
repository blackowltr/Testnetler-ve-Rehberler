# Nulink Testnet Guide

![NULINK](https://user-images.githubusercontent.com/107190154/190568136-14f5a7d8-5b15-46fb-8132-4d38a0779171.gif)

### I created this guide so that you can easily install it with the help of a script.

### The passwords you use during installation must be 8 characters. 

### All passwords that you created during installation must be the same.

### Run this script to start the installation

```
```

## You will create a password in this section.

![image](https://user-images.githubusercontent.com/107190154/190849869-e11d4ed6-f558-4902-8d93-1eb5cad3b7ed.png)

## The public address of the key and the Path to the secret key file make a note of this information somewhere, it is important.

![image](https://user-images.githubusercontent.com/107190154/190849872-4a58ec31-866e-4bbe-8833-2490aaf80773.png)

## Type the directory path of the secret key file in this section as follows.

![image](https://user-images.githubusercontent.com/107190154/190849879-813d76de-0a9d-408d-85d3-e4bb3ab82adb.png)

## Type in your public address, and then type in the secret key from the section of your file that starts with UTC
> Study the example in the photo.

![image](https://user-images.githubusercontent.com/107190154/190849908-1d09cc10-bddb-4da3-b106-d5d30be724fd.png)

## The words written in blue are your seed words. Don't lose them. Make a note of.

![image](https://user-images.githubusercontent.com/107190154/190849993-a2a18f42-bba5-497b-8f47-4b1ad8c3e7ef.png)

## In the Confirm seed words section, we write the words that were just written in blue

![image](https://user-images.githubusercontent.com/107190154/190851095-8f445beb-c140-4ba9-b8f7-fc536f2a04f1.png)

## And the installation is now completed successfully, you can check your logging.

![image](https://user-images.githubusercontent.com/107190154/190850125-a19d0d20-dc40-4d09-8951-b43941f394b0.png)

## [See here for the last remaining steps](https://docs.nulink.org/products/staking_dapp)

### Log Control:
```
docker logs -f ursula
```
### if you see an output like the following when you check the log, this is not a problem. The reason for this; This is because the worker would send a confirm transaction to blockchain. It will automatically calculate the gas price using web3 library. And the price is too low so the transaction pool do not handling this transaction.
Anlaşmazlık kimliği: blackowl#7099
