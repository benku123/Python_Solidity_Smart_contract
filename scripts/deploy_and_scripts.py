from .helpful_scripts import get_account
from brownie import SimpleCollectable

sample_token_uri = "ipfs://Qmd9MCGtdVz2miNumBHDbvj8bigSgTwnr4SbyH6DNnpWdt?filename=0-PUG.json"

import json

def main():
    account = get_account()
    initial_price = 1000

    simple_collectible = SimpleCollectable.deploy(initial_price, {"from": account})
    tx = simple_collectible.createCollectable(sample_token_uri, {"from": account})
    tx.wait(1)
    print(f"Minted token. Transaction hash: {tx.txid}")

    with open('contract_address.txt', 'w') as f:
        f.write(simple_collectible.address)

    with open('contract_abi.json', 'w') as f:
        json.dump(simple_collectible.abi, f)