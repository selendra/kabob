import { Wallet } from 'ethers';


async function getPrivateKey(mnemonic: string) {
    return new Promise(async (resolve, reject) => {
        const walletMnemonic = Wallet.fromMnemonic(mnemonic);
        resolve(walletMnemonic.privateKey);
    });
}


export default {
    getPrivateKey,

};