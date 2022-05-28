// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Tamagotchi.sol";

interface CheatCodes {
    function warp(uint256) external;
}

contract TamagotchiTest is Test {
    Tamagotchi public tg;
    CheatCodes constant cheats = CheatCodes(HEVM_ADDRESS);

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
    function testPlay() public {
        tg.passTime(0);
        (uint256 happiness, , uint256 enrichment, , ) = tg.getStats(0);
        assertEq(enrichment, 90);
        assertEq(happiness, (90 + 90) / 2);
        tg.play();
        (happiness, , enrichment, , ) = tg.getStats(0);
        assertEq(enrichment, 100);
        assertEq(happiness, (90 + 100) / 2);
    }

    //test svg image
    function testImgURI() public {
        (, , , , string memory tokenURI) = tg.getStats(0);
        string memory initURI = tokenURI;

        // second state (90)
        tg.passTime(0);
        (, , , , tokenURI) = tg.getStats(0);
        string memory secondURI = tokenURI;
        assertTrue(
            keccak256(abi.encodePacked(initURI)) !=
                keccak256(abi.encodePacked(tokenURI))
        );
        // still second state (80)
        tg.passTime(0);
        (, , , , tokenURI) = tg.getStats(0);

        assertTrue(
            keccak256(abi.encodePacked(tokenURI)) ==
                keccak256(abi.encodePacked(secondURI))
        );
        // 3rd state (60)
        tg.passTime(0);
        tg.passTime(0);
        (, , , , tokenURI) = tg.getStats(0);
        string memory thirdURI = tokenURI;
        assertTrue(
            keccak256(abi.encodePacked(secondURI)) !=
                keccak256(abi.encodePacked(thirdURI))
        );
        // 4th state (30)
        tg.passTime(0);
        tg.passTime(0);
        tg.passTime(0);
        (, , , , tokenURI) = tg.getStats(0);
        string memory fourthURI = tokenURI;
        assertTrue(
            keccak256(abi.encodePacked(fourthURI)) !=
                keccak256(abi.encodePacked(thirdURI))
        );
        // still 4th state (10)
        tg.passTime(0);
        tg.passTime(0);
        (, , , , tokenURI) = tg.getStats(0);
        assertTrue(
            keccak256(abi.encodePacked(fourthURI)) ==
                keccak256(abi.encodePacked(tokenURI))
        );
        // 5th state (0)
        tg.passTime(0);
        (, , , , tokenURI) = tg.getStats(0);
        string memory fifthURI = tokenURI;
        assertTrue(
            keccak256(abi.encodePacked(fourthURI)) !=
                keccak256(abi.encodePacked(fifthURI))
        );
        // still 5th state (0)
        tg.passTime(0);
        (, , , , tokenURI) = tg.getStats(0);
        assertTrue(
            keccak256(abi.encodePacked(tokenURI)) ==
                keccak256(abi.encodePacked(fifthURI))
        );
    }

    //Check upkeep
    function testCheckUpkeep() public {
        bytes memory data = "";
        bool upkeepNeeded = tg.checkUpkeep(data);
        assertFalse(upkeepNeeded);
        cheats.warp(block.timestamp + 50);
        (upkeepNeeded) = tg.checkUpkeep(data);
        assertFalse(upkeepNeeded);
        cheats.warp(block.timestamp + 51); //101 total
        (upkeepNeeded) = tg.checkUpkeep(data);
        assertTrue(upkeepNeeded);
    }

    //Perform upkeep
    function testPerformUpkeep() public {
        bytes memory data = "";
        //nothing should happen
        tg.performUpkeep(data);
        (
            uint256 happiness,
            uint256 satiety,
            uint256 enrichment,
            uint256 lastChecked,

        ) = tg.getStats(0);
        assertEq(satiety, 100);
        assertEq(enrichment, 100);
        assertEq(happiness, 100);
        assertEq(lastChecked, block.timestamp);

        //passTime() should be called
        cheats.warp(block.timestamp + 101);
        tg.performUpkeep(data);
        (happiness, satiety, enrichment, lastChecked, ) = tg.getStats(0);
        assertEq(satiety, 90);
        assertEq(enrichment, 90);
        assertEq(happiness, (90 + 90) / 2);
        assertEq(lastChecked, block.timestamp);
    }
}
