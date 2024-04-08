<template>
  <h1>{{ msg }}</h1>

  <div class="card">
    <button v-if="!isConnected" type="button" @click="connectWallet()">Connect to wallet</button>
    <div v-else> The connected wallet address is {{ connectedAddress }}</div>
  </div>

</template>

<script setup>
import { ref } from 'vue';
// uses the ethers project package , Provides functionalities to interact with the Ethereum blockchain using Ethers.js.
import { Web3Provider } from '@ethersproject/providers';

const isConnected = ref(false);
const connectedAddress = ref(null);

const connectWallet = async() => {
  const { ethereum } = window;
  if (!ethereum) {
    console.error("MetaMask not detected");
    return;
  }

  console.log("Connecting to wallet");
  
  // opens meta mask on the browser
  const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
  
  // A Web3Provider wraps a standard Web3 provider, which is
  // what MetaMask injects as window.ethereum into each page
  const provider = new Web3Provider(ethereum);

  // gets the address that is connected
  const signer = provider.getSigner();
  const address = await signer.getAddress()

  // You can now use the provider and signer objects to interact with the blockchain
  console.log("Connected! Address:", address);
  
  isConnected.value = true;
  connectedAddress.value = address;
}

defineProps({
  msg: String,
})

const count = ref(0)
</script>


<style scoped>
.read-the-docs {
  color: #888;
}
</style>
