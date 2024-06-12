from brownie import SimpleCollectable, accounts,config
import json

sample_token_uri = "ipfs://Qmd9MCGtdVz2miNumBHDbvj8bigSgTwnr4SbyH6DNnpWdt?filename=0-PUG.json"

def main():
    # Load your account from the private key
    account = accounts.add(config['wallets']['from_key'])
    initial_price = 1000

    # Deploy the SimpleCollectable contract
    simple_collectible = SimpleCollectable.deploy({"from": account})
    print(f"Contract deployed at address: {simple_collectible.address}")


    # Save contract address to a file
    with open('contract_address.txt', 'w') as f:
        f.write(simple_collectible.address)

    # Save contract ABI to a file
    abi = simple_collectible.abi
    with open('contract_abi.json', 'w') as f:
        json.dump(abi, f)

    print("Contract address and ABI saved.")
