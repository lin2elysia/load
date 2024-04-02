#!/bin/sh

# Change the following address to your ETH addr.
ADDRESS=rQtaAuzdmc8iQQfwbACLJAd5N6Yed29wd5

USERNAME=Lin
POOL=127.0.0.1:444
# Change SCHEME according to your POOL. For example:
# ethash:     Nanopool
# ethproxy:   BTC.com, Ethermine, PandaMiner, Sparkpool
# ethstratum: Antpool.com, BTC.com, F2pool, Huobipool.com, Miningpoolhub
SCHEME=raven

./bminer -uri $SCHEME://$USERNAME@$POOL
