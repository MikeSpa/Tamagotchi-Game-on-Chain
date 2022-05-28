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
            uint256 hunger,
            uint256 enrichment,
            uint256 lastChecked,

        ) = tg.getStats(0);
        assertEq(happiness, (hunger + enrichment) / 2);
        assertEq(hunger, 100);
        assertEq(enrichment, 100);
        assertEq(lastChecked, block.timestamp);
    }

    //Test URI for my Gotchi
    function testMyGotchiURI() public {
        (
            uint256 happiness,
            uint256 hunger,
            uint256 enrichment,
            uint256 lastChecked,

        ) = tg.getMyGotchiStats();
        assertEq(happiness, (hunger + enrichment) / 2);
        assertEq(hunger, 100);
        assertEq(enrichment, 100);
        assertEq(lastChecked, block.timestamp);
    }

    //Test passing time
    function testPassTime() public {
        tg.passTime(0);
        (uint256 happiness, uint256 hunger, uint256 enrichment, , ) = tg
            .getStats(0);
        assertEq(hunger, 90);
        assertEq(enrichment, 90);
        assertEq(happiness, (90 + 90) / 2);
    }

    //Test feed

    //test play

    //test svg image

    //Check upkeep

    //Perform upkeep
}
