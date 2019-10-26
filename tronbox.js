require("dotenv").config();

console.info(process.env.PK);

module.exports = {
  networks: {
    development: {
      privateKey:
        "da146374a75310b9666e834ee4ad0866d6f4035967bfc76217c5a495fff9f0d0",
      consume_user_resource_percent: 30,
      fee_limit: 1e9,

      fullHost: "http://127.0.0.1:9090",

      network_id: "*"
    },
    mainnet: {
      privateKey: process.env.PK,
      consume_user_resource_percent: 30,
      fee_limit: 1e9,

      fullHost: "https://api.trongrid.io",

      network_id: "*"
    },
    shasta: {
      privateKey: process.env.PK,
      consume_user_resource_percent: 30,
      fee_limit: 1e9,

      fullHost: "https://api.shasta.trongrid.io",

      network_id: "*"
    }
  }
};
