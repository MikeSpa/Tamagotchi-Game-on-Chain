<script>
	import Tamagotchi from '$lib/Tamagotchi.svelte';
	import WalletConnect from '$lib/WalletConnect.svelte';
	import TamagotchiAbi from '../contracts/Tamagotchi.json';

	const contractAddr = '0x63c5AC5625C3cF34897CE04dC8b18Ba5b7fbcfE6';
	export let web3Props = {
		provider: null,
		signer: null,
		account: null,
		chainId: null,
		contract: null
	};
</script>

<h1>My Tamagotchi</h1>
{#if !web3Props.account}
	<WalletConnect bind:web3Props {contractAddr} contractAbi={TamagotchiAbi} />
{:else}
	<Tamagotchi {web3Props} />
{/if}
