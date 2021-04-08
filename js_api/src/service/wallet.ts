import { ethers, Wallet } from 'ethers';



async function getPrivateKey(mnemonic: string) {
    return new Promise(async (resolve, reject) => {
        const walletMnemonic = Wallet.fromMnemonic(mnemonic);
        resolve(walletMnemonic.privateKey);
    });
}

async function validateEtherAddr(address: string) {
    return new Promise(async (resolve, reject) => {
        const isEtherAddress = ethers.utils.isAddress(address);
        resolve(isEtherAddress);
    });
}


export default {
    getPrivateKey,
    validateEtherAddr,
};