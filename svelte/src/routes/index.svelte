<script>
	import WalletConnect from '$lib/WalletConnect.svelte';
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
	<WalletConnect bind:web3Props />
{:else}
	<h2>?</h2>
{/if}
