import { ethers } from "ethers";
import dotenv from "dotenv";
import chalk from "chalk";

import csv from "fast-csv";

dotenv.config();

const provider = new ethers.providers.JsonRpcProvider(process.env.POLYGON);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY);
const account = wallet.connect(provider);

const abi = ["function adminMintL1(address _to) external"];

const run = async () => {
  const contract = new ethers.Contract(
    process.env.CONTRACT_ADDRESS,
    abi,
    account
  );

  var dataArr = [];
  csv
    .parseFile("airdrop_whitelist.csv", { headers: true })
    .on("data", (data) => {
      dataArr.push(data);
    })
    .on("end", async () => {
      console.log(dataArr.length);

      for (let i = 0; i < dataArr.length; i++) {
        console.log(dataArr[i].wallet);
        await contract.adminMintL1(ethers.utils.getAddress(dataArr[i].wallet));
      }
    });
};

await run();
