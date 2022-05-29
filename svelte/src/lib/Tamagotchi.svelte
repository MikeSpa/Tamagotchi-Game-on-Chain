<script>
	import Bar from './Bar.svelte';
	import Face from './Face.svelte';
	export let web3Props = {
		provider: null,
		signer: null,
		account: null,
		chainId: null,
		contract: null
	};
	$: image = '';
	$: satiety = 0;
	$: enrichment = 0;
	$: happiness = 42;
	//Get value from contract on blockchain
	const getMyTamagotchiStats = async () => {
		let currentGotchi = await web3Props.contract.getMyGotchiStats();
		happiness = await currentGotchi[0].toNumber();
		satiety = await currentGotchi[1].toNumber();
		enrichment = await currentGotchi[2].toNumber();
		image = await currentGotchi[4];
		web3Props.contract.on('TamagotchiUpdate', async () => {
			currentGotchi = await web3Props.contract.getMyGotchiStats();

			happiness = await currentGotchi[0].toNumber();
			satiety = await currentGotchi[1].toNumber();
			enrichment = await currentGotchi[2].toNumber();
			image = await currentGotchi[4];
		});
	};
	getMyTamagotchiStats();
</script>

<div>
	<Face {image} />
</div>
<div>
	Satiety: {satiety}
	<br />
	<Bar bind:status={satiety} />
	<button
		on:click={() => {
			web3Props.contract.feed();
		}}>Feed</button
	>
</div>
<div>
	Enrichment: {enrichment}
	<br />

	<Bar bind:status={enrichment} />
	<button
		on:click={() => {
			web3Props.contract.play();
		}}>Play</button
	>
</div>
<div>
	Happiness: {happiness}
	<Bar bind:status={happiness} />
</div>

<style>
	div {
		width: 33%;
	}
</style>
