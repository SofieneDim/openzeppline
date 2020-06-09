pragma experimental ABIEncoderV2;
pragma solidity >0.4.99 <0.6.0;


contract testy {
    uint256[] public pages;

    constructor() public {
        pages = [
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            10,
            11,
            12,
            13,
            14,
            15,
            16,
            17,
            18,
            19,
            20,
            21,
            23,
            24,
            25,
            26,
            27,
            28,
            29,
            30,
            31,
            32,
            34,
            35,
            36,
            37,
            38,
            39
        ];
    }

    function getPages(uint256 lot)
        public
        view
        returns (uint256[] memory pagesToReturn)
    {
        uint256[] memory finalePages = new uint256[](10);
        uint256 counter = 0;
        uint256 from = pages.length - 1 - (lot * 10) + 10;
        uint256 to = from - 9;

        for (uint256 i = from; i >= to && i >= 0; i--) {
            finalePages[counter] = pages[i];

            counter++;
        }
        return finalePages;
    }
}
