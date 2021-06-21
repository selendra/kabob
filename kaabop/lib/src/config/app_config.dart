/* This file hold app configurations. */
class AppConfig {
  bool isDark;
  /* Background Color */
  static const String darkBlue50 = "#344051",
      bgdColor = "#090D28"; // App Theme using darkBlue75

  static const String lightBgdColor = '#F5F5F5';
  /* ------------------- Logo -----------------  */

  // Welcome Screen, Login Screen, Sign Up Screen
  static String logoName = "assets/sld_logo.svg";

  // Dashbaord Menu
  static String logoAppBar = "assets/images/zeetomic-logo-header.png";

  // Bottom App Bar
  static String logoBottomAppBar = "assets/images/sld_qr.png";

  // QR Embedded
  static String logoQrEmbedded =
      "assets/SelendraQr-1.png"; //"assets/sld_stroke.png";

  // Portfolio
  static String logoPortfolio = 'assets/images/sld_logo.png';

  // Transaction History
  static String logoTrxHistory = 'assets/images/sld_logo.png';

  /* Splash Screen */
  static String splashLogo = "assets/images/zeetomic-logo-header.png";

  /* Transaction Acivtiy */
  static String logoTrxActivity = 'assets/images/sld_logo.png';

  /* Zeetomic api user data*/
  // Main Net API
  static const url = "https://testnet-api.selendra.com/pub/v1";

  static const bscTestNet = 'https://data-seed-prebsc-1-s1.binance.org:8545';

  static const bscMainNet = 'https://bsc-dataseed.binance.org/';

  //static const bscAddr = '0xd84d89d5c9df06755b5d591794241d3fd20669ce';

  static const etherTestnet =
      'https://rinkeby.infura.io/v3/93a7248515ca45d0ba4bbbb8c33f1bda';

  static const etherMainet =
      'https://mainnet.infura.io/v3/93a7248515ca45d0ba4bbbb8c33f1bda';

  static const etherTestnetWebSocket =
      'wss://rinkeby.infura.io/ws/v3/93a7248515ca45d0ba4bbbb8c33f1bda';

  static const coingeckoBaseUrl =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=';

  static const bscMainnetAddr = '0x288d3A87a87C284Ed685E0490E5C4cC0883a060a';

  static const kgoAddr = '0x5d3AfBA1924aD748776E4Ca62213BF7acf39d773';

  static const kmpiAddr = '5GZ9uD6RgN84bpBuic1HWq9AP7k2SSFtK9jCVkrncZsuARQU';

  //test 0x78F51cc2e297dfaC4c0D5fb3552d413DC3F71314

  static const nodeName = 'Indranet hosted By Selendra';

  static const nodeEndpoint = 'wss://rpc-testnet.selendra.org';

  static const dotTestnet = 'wss://westend-rpc.polkadot.io';

  static const dotMainnet = 'wss://rpc.polkadot.io';

  static int ss58 = 42;

  static const spreedSheetId = '1hFKqaUe1q_6A-b-_ZnEAC574d51fCi1bTWQKCluHF2E';

  static const nodeListPolkadot = [
    {
      'name': 'Polkadot (Live, hosted by PatractLabs)',
      'ss58': 0,
      'endpoint': 'wss://polkadot.elara.patract.io',
    },
    {
      'name': 'Polkadot (Live, hosted by Polkawallet CN)',
      'ss58': 0,
      'endpoint': 'wss://polkadot-1.polkawallet.io:9944',
    },
    {
      'name': 'Polkadot (Live, hosted by Polkawallet EU)',
      'ss58': 0,
      'endpoint': 'wss://polkadot-2.polkawallet.io',
    },
    {
      'name': 'Polkadot (Live, hosted by Parity)',
      'ss58': 0,
      'endpoint': 'wss://rpc.polkadot.io',
    },
    {
      'name': 'Polkadot (Live, hosted by onfinality)',
      'ss58': 0,
      'endpoint': 'wss://polkadot.api.onfinality.io/public-ws',
    },
  ];

  static const testInviteLink =
      'https://selendra-airdrop.netlify.app/invitation?ref=';

  static const testInviteLink1 =
      'https://selendra-airdrop.netlify.app/claim-\$sel?ref=';

  static const baseInviteLink = 'https://airdrop.selendra.org/claim-\$sel?ref=';

  //static const credentials = ' ';

  //
  // sld_market net API
  // https://sld_marketnet-api.selendra.com/pub/v1

  static const credentials = r'''
{
  "type": "service_account",
  "project_id": "",
  "private_key_id": "",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDHnrICGcf5xd+P\nTgd18bI4Yl5fjQyVXQXyuUn+yqmo+fipJ0PNHYj4ffk4IYnp/xvPyv/c08sThPE6\n9mgu0TmrjOJoH/ix7nmtDSibtvBF3JmkqoReyHxbSYTprhkvMvy1ulkvqRte6ZFV\nmmSIuSxh8MHl6lsFVj1FpYXXZYhdKd9rqRVsnEtQ0XBZcYGE4AkK2ocGg9WY2grq\nSWu0JEhDopE1qYB2/UVEnZUVESs0ieQoafqwYf6oAEyGPKY+VtyuNcRGpqiT/B8P\nSehQcm1LD19iRkrD2SRx7uW151R9H/m3tdbMPjov03W17tQlxuSph9jWs1acrJHI\neZ1+81XXAgMBAAECggEAUkJoq2nxWNG8JwMqGuXPIeITbr+inFhZj6TgQ7FDCeF8\noUQPchKGM5RB42oauYUJcm7+UgMq76+8cqZA124bnEBxuiPWqYgStwexoL1ZtQhL\nfipQYviuGjYpIdy+/w69SavxfazrnQiV/dciL59TFUcPuA2Dlabsl+s2RMVP1Mel\nZF6ai8AzS9s31Z3RDTPMslescghP6Wl1BnFDAkI2fpsu3VfFlImSDl4tMDf0p9wt\nAFz3vro/lBAk1dZJKqPWxMFlgskHnwtmUqTG7xJY5xs1cCF2QhddMbea7NMQmn0m\nUSMFPNl+Sgacduj6HESB1YvjzHPIvhiOpInF4JXXSQKBgQD+5io88yZg6cuTMsqt\nDIuqQilzjlZxILR3aDknA90E49TK9bQuyjkzbdiWfBy4P72sAr98kRVd6twX+cqY\nqBmF5sryW33GHyNY2xWPfF6L+DWWmfFCU4qNkUeyATVegUDjdm3GuGWiUeF88En8\nQCYRatLkQIQssZabI+nRU9G0rwKBgQDIe2jfpZfqxYaQ3mK0ww41/l05ndS76a4u\neZdWf/OJJv9+OztKXQyUdoBU1xlhllzgwg3aRIifouQz4p/gIBYIyu63Pg4PMVwC\noPB+gA0mckcnpuLAtr2zq3tBS4EsD+wajRVdT38ZSoG1rsyyzXSEuAAlWWJE3TNe\n0rPXzjgLWQKBgQC+6yhR1JE3X4XyL8XsjYwCr2Gaws7uFt/02+SK23LtGbSlfBlE\nPoVPhwQF2tosCtoG/1vrckO9v46wipD7fFT5nR7/HhX7khEImbfxa+bpEbUZox44\nXphVZq57njoaGde/R1H72NuPE6M/0D6qKGYa/5cMDWKykyVJ+EFGX3Cf0wKBgQCm\nrFrbHFt5dnBSfmBHcaad4vP0U7Ap7bO+tZ3I7yU0EDT26B15zHQJ9Z7pac6TICPl\nQ8+qd7GyLgVU0YMjHOnUs4nU1AVyQhIBqXVnZeQI45cecxMvLn32IomdFj20uSQM\nSuDJK686AoRl3IYX3NGTCTot0urs3422tquHrc1QOQKBgCF+G6OYbMMdy1OZXx/w\n0BlgObMf6OtRwfIq39crLk60EFKC4AEC/+2LY8cCoTDv1WDQaucy+W1LOizXAaUs\nUkyJdYZCBeJI6Gc8TYXSp0NXhm0PCjkOnV/Pgc7CgcZU8AZlrGzzjjr2x+ewFLc6\nOGqUfeNXzEbxPP4ts38iWzMi\n-----END PRIVATE KEY-----\n",
  "client_email": "airdrop@airdrop-310108.iam.gserviceaccount.com",
  "client_id": "",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": ""
}
''';
}
