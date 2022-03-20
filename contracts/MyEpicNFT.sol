// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
// いくつかの OpenZeppelin のコントラクトをインポートします。
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// インポートした OpenZeppelin のコントラクトを継承しています。
// 継承したコントラクトのメソッドにアクセスできるようになります。
contract MyEpicNFT is ERC721URIStorage {

  // OpenZeppelin が tokenIds を簡単に追跡するために提供するライブラリを呼び出しています
  using Counters for Counters.Counter;

  // _tokenIdsを初期化（_tokenIds = 0）
  Counters.Counter private _tokenIds;

  // SVGコードを作成します。
  // 変更されるのは、表示される単語だけです。
  // すべてのNFTにSVGコードを適用するために、baseSvg変数を作成します。
  string baseSvg = "<svg width='955' height='626' overflow='visible' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 955 626'><defs><clipPath id='a'><path pointer-events='all' d='M235.8 71.3h483.4v483.4H235.8z'/></clipPath></defs><g class='layer' style='pointer-events:all' clip-path='url(#a)'><g style='color-interpolation-filters:sRGB;pointer-events:none'><path fill='#d0d059' style='color-interpolation-filters:sRGB' d='M235.8 71.3h483.4v483.4H235.8z'/></g><path fill='#9fa83f' d='M572.729-71.375v421h-268v-421h268z' paint-order='stroke' vector-effect='non-scaling-stroke' stroke='#9fa83f' transform='matrix(1.79679 0 0 .59002 -310.804 230.913)'/></g><text fill='#404f11' font-size='300%' x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // 3つの配列 string[] に、それぞれランダムな単語を設定しましょう。
  string[] firstWords = ["El", "La", "Un", "Una", "Mi", "Tu"];
  string[] secondWords = ["Pollo", "Vaca", "Caballo", "Hamster", "Queso", "Pato"];
  string[] thirdWords = ["Gordo", "Guapa", "Vieja", "Sabroso", "Larga", "Gorda"];

  // NFT トークンの名前とそのシンボルを渡します。
  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("This is my NFT contract.");
  }

  // シードを生成する関数を作成します。
  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  // 各配列からランダムに単語を選ぶ関数を3つ作成します。
  // pickRandomFirstWord関数は、最初の単語を選びます。
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {

    // pickRandomFirstWord 関数のシードとなる rand を作成します。
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));

    // seed rand をターミナルに出力する。
	  console.log("rand seed: ", rand);

	  // firstWords配列の長さを基準に、rand 番目の単語を選びます。
    rand = rand % firstWords.length;

	  // firstWords配列から何番目の単語が選ばれるかターミナルに出力する。
	  console.log("rand first word: ", rand);
    return firstWords[rand];
  }

  // pickRandomSecondWord関数は、2番目に表示されるの単語を選びます。
  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {

    // pickRandomSecondWord 関数のシードとなる rand を作成します。
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  // pickRandomThirdWord関数は、3番目に表示されるの単語を選びます。
  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {

    // pickRandomThirdWord 関数のシードとなる rand を作成します。
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  // ユーザーが NFT を取得するために実行する関数です。
  function makeAnEpicNFT() public {

    // 現在のtokenIdを取得します。tokenIdは0から始まります。
    uint256 newItemId = _tokenIds.current();

    // 3つの配列からそれぞれ1つの単語をランダムに取り出します。
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);

    // 3つの単語を連結して、<text>タグと<svg>タグで閉じます。
    string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

	// NFTに出力されるテキストをターミナルに出力します。
    console.log("\n--------------------");
    console.log(finalSvg);
    console.log("--------------------\n");

    // msg.sender を使って NFT を送信者に Mint します。
    _safeMint(msg.sender, newItemId);

	// tokenURI は後で設定します。
	// 今は、tokenURI の代わりに、"We will set tokenURI later." を設定します。
	_setTokenURI(newItemId, "We will set tokenURI later.");

	// NFTがいつ誰に作成されたかを確認します。
	console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // 次の NFT が Mint されるときのカウンターをインクリメントする。
    _tokenIds.increment();
  }
}
