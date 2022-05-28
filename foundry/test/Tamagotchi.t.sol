// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Tamagotchi.sol";

contract TamagotchiTest is Test {
    Tamagotchi public tg;

    // Run before every test
    function setUp() public {
        tg = new Tamagotchi();
        address addy = 0xf74Bdac96015b303a6ac9dcD7254be05C9fA3ad4;
        tg.safeMint(addy);
    }

    //Mint NFT
    function testMint() public {
        address addy = 0xf74Bdac96015b303a6ac9dcD7254be05C9fA3ad4;
        address owner = tg.ownerOf(0);
        assertEq(addy, owner);
    }

    //Test URI
    function testURI() public {
        (
            uint256 happiness,
            uint256 satiety,
            uint256 enrichment,
            uint256 lastChecked,

        ) = tg.getStats(0);
        assertEq(happiness, (satiety + enrichment) / 2);
        assertEq(satiety, 100);
        assertEq(enrichment, 100);
        assertEq(lastChecked, block.timestamp);
    }

    //Test URI for my Gotchi
    function testMyGotchiURI() public {
        (
            uint256 happiness,
            uint256 satiety,
            uint256 enrichment,
            uint256 lastChecked,

        ) = tg.getMyGotchiStats();
        assertEq(happiness, (satiety + enrichment) / 2);
        assertEq(satiety, 100);
        assertEq(enrichment, 100);
        assertEq(lastChecked, block.timestamp);
    }

    //Test passing time
    function testPassTime() public {
        tg.passTime(0);
        (uint256 happiness, uint256 satiety, uint256 enrichment, , ) = tg
            .getStats(0);
        assertEq(satiety, 90);
        assertEq(enrichment, 90);
        assertEq(happiness, (90 + 90) / 2);
    }

    //Test feed
    function testFeed() public {
        tg.passTime(0);
        (uint256 happiness, uint256 satiety, , , ) = tg.getStats(0);
        assertEq(satiety, 90);
        assertEq(happiness, (90 + 90) / 2);
        tg.feed();
        (happiness, satiety, , , ) = tg.getStats(0);
        assertEq(satiety, 100);
        assertEq(happiness, (100 + 90) / 2);
    }

    //test play

    //test svg image

    //Check upkeep

    //Perform upkeep
}
